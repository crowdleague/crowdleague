import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdleague/middleware/app_middleware.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/reducers/app_reducer.dart';
import 'package:crowdleague/services/auth_service.dart';
import 'package:crowdleague/services/database_service.dart';
import 'package:crowdleague/services/device_service.dart';
import 'package:crowdleague/services/notifications_service.dart';
import 'package:crowdleague/services/storage_service.dart';
import 'package:crowdleague/utils/redux/redux_bundle.dart';
import 'package:crowdleague/utils/redux/store_operation.dart';
import 'package:crowdleague/utils/wrappers/apple_signin_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:redux/src/store.dart';

class FakeReduxBundle implements ReduxBundle {
  static var _bucketName = 'gs://crowdleague-profile-pics';
  static var _extraMiddlewares = <Middleware>[];
  static var _storeOperations = <StoreOperation>[];
  static Settings _firestoreSettings;

  static void setup(
      {String bucketName,
      List<Middleware> extraMiddlewares,
      List<StoreOperation> storeOperations,
      Settings firestoreSettings}) {
    _bucketName = bucketName ?? _bucketName;
    _extraMiddlewares = extraMiddlewares ?? _extraMiddlewares;
    _storeOperations = storeOperations ?? _storeOperations;
    _firestoreSettings = firestoreSettings;
  }

  /// Services
  final AuthService _authService;
  final DatabaseService _databaseService;
  final NotificationsService _notificationsService;
  final StorageService _storageService;
  final DeviceService _deviceService;

  FakeReduxBundle(
      {List<Middleware> extraMiddlewares,
      AuthService authService,
      DatabaseService databaseService,
      NotificationsService notificationsService,
      StorageService storageService,
      DeviceService deviceService})
      : _authService = authService ??
            AuthService(
              FirebaseAuth.instance,
              GoogleSignIn(scopes: <String>['email']),
              AppleSignInWrapper(),
            ),
        _databaseService =
            databaseService ?? DatabaseService(FirebaseFirestore.instance),
        _notificationsService =
            notificationsService ?? NotificationsService(FirebaseMessaging()),
        _storageService = storageService ??
            StorageService(
              FirebaseStorage(
                  app: FirebaseFirestore.instance.app,
                  storageBucket: _bucketName),
            ),
        _deviceService =
            deviceService ?? DeviceService(imagePicker: ImagePicker());

  @override
  AuthService get auth => throw UnimplementedError();

  @override
  Future<Store<AppState>> createStore() async {
    final _store = Store<AppState>(
      appReducer,
      initialState: AppState.init(),
      middleware: [
        ...createAppMiddleware(
            authService: _authService,
            databaseService: _databaseService,
            notificationsService: _notificationsService,
            storageService: _storageService,
            deviceService: _deviceService),
        ..._extraMiddlewares
      ],
    );

    // now that we have a store, run any store operations that were added
    for (final operation in _storeOperations) {
      await operation.runOn(_store);
    }

    // finally, if firestore settings were added, set the instance to use them
    if (_firestoreSettings != null) {
      // TODO: figure out how to be able to call this (it throws, I think
      // because the Firebase instance isn't ready)
      // FirebaseFirestore.instance.settings = _firestoreSettings;
    }

    return _store;
  }

  @override
  DatabaseService get database => throw UnimplementedError();

  @override
  DeviceService get device => throw UnimplementedError();

  @override
  NotificationsService get notifications => throw UnimplementedError();

  @override
  StorageService get storage => throw UnimplementedError();
}
