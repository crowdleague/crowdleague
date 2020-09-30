import 'package:crowdleague/actions/auth/observe_auth_state.dart';
import 'package:crowdleague/actions/database/plumb_database_stream.dart';
import 'package:crowdleague/actions/device/check_platform.dart';
import 'package:crowdleague/actions/notifications/print_fcm_token.dart';
import 'package:crowdleague/actions/notifications/request_fcm_permissions.dart';
import 'package:crowdleague/extensions/extensions.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/app/settings.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:crowdleague/utils/redux/navigation_info_recorder.dart';
import 'package:crowdleague/utils/redux/services_bundle.dart';
import 'package:crowdleague/widgets/auth/auth_page.dart';
import 'package:crowdleague/widgets/auth/other_auth_options_page.dart';
import 'package:crowdleague/widgets/chats/messages/messages_page.dart';
import 'package:crowdleague/widgets/chats/new_conversation/new_conversation_page.dart';
import 'package:crowdleague/widgets/main/main_page.dart';
import 'package:crowdleague/widgets/profile/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CrowdLeagueApp extends StatefulWidget {
  @override
  _CrowdLeagueAppState createState() => _CrowdLeagueAppState();
}

class _CrowdLeagueAppState extends State<CrowdLeagueApp> {
  final _navKey = GlobalKey<NavigatorState>();
  Store<AppState> _store;
  dynamic _error;
  bool _initializedFirebase = false;
  bool _initializedRedux = false;

  // Define an async function to initialize FlutterFire
  void initialize() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initializedFirebase = true;
      });

      final services = ServicesBundle(navKey: _navKey);
      _store = await services.createStore();
      setState(() {
        _initializedRedux = true;
      });

      // dispatch initial actions
      _store.dispatch(ObserveAuthState());
      _store.dispatch(RequestFCMPermissions());
      _store.dispatch(PrintFCMToken());
      _store.dispatch(CheckPlatform());

      /// This should happen once on app load, the various streams from the
      /// [FirebaseFirestore] database are changed but the [DatabaseService] stream
      /// controller is connected to the redux [Store] then remains unchanged.
      _store.dispatch(PlumbDatabaseStream());
    } catch (e) {
      setState(() {
        _error = e;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return ErrorPage(error: _error, trace: StackTrace.current);
    }

    // Show a loader until FlutterFire is initialized
    if (!_initializedFirebase || !_initializedRedux) {
      return InitializingIndicator(
        firebaseDone: _initializedFirebase,
        reduxDone: _initializedRedux,
      );
    }

    return StoreProvider<AppState>(
      store: _store,
      child: StoreConnector<AppState, Settings>(
          distinct: true,
          converter: (store) => store.state.settings,
          builder: (context, settings) {
            return MaterialApp(
              navigatorKey: _navKey,
              navigatorObservers: [NavigationInfoRecorder(_store)],
              theme: ThemeDataExt.from(settings.lightTheme),
              darkTheme: ThemeDataExt.from(settings.darkTheme),
              themeMode: ThemeModeExt.from(settings.brightnessMode),
              home: CheckAuth(), // becomes the route named '/'
              routes: <String, WidgetBuilder>{
                '/other_auth_options': (context) => OtherAuthOptionsPage(),
                '/conversation': (context) => MessagesPage(),
                '/new_conversation': (context) => NewConversationPage(),
                '/profile': (context) => ProfilePage()
              },
            );
          }),
    );
  }
}

class CheckAuth extends StatelessWidget {
  const CheckAuth({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, User>(
        distinct: true,
        converter: (store) => store.state.user,
        builder: (context, user) {
          return (user == null || user.id == null) ? AuthPage() : MainPage();
        });
  }
}

class InitializingIndicator extends StatelessWidget {
  final bool firebaseDone;
  final bool reduxDone;
  const InitializingIndicator({
    @required this.firebaseDone,
    @required this.reduxDone,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var message = '';
    if (!firebaseDone && !reduxDone) {
      message = 'Waiting for Redux & Firebase...';
    } else if (!firebaseDone) {
      message = 'Waiting for Firebase...';
    } else if (!reduxDone) {
      message = 'Waiting for Redux...';
    }
    return Material(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 30),
            Text(message, textDirection: TextDirection.ltr)
          ]),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final dynamic _error;
  final StackTrace _trace;
  const ErrorPage({
    @required dynamic error,
    @required StackTrace trace,
    Key key,
  })  : _error = error,
        _trace = trace,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            SizedBox(height: 50),
            Text('Looks like there was a problem.',
                textDirection: TextDirection.ltr),
            SizedBox(height: 20),
            Text(_error.toString(), textDirection: TextDirection.ltr),
            SizedBox(height: 50),
            Text(_trace.toString(), textDirection: TextDirection.ltr),
          ],
        ),
      ),
    );
  }
}
