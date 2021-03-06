import 'package:built_collection/built_collection.dart';
import 'package:crowdleague/actions/auth/clear_user_data.dart';
import 'package:crowdleague/models/app/app_state.dart';
import 'package:crowdleague/models/auth/provider_info.dart';
import 'package:crowdleague/models/auth/user.dart';
import 'package:crowdleague/models/navigation/page_data/email_auth_page_data.dart';
import 'package:crowdleague/models/navigation/page_data/page_data.dart';
import 'package:crowdleague/reducers/auth/clear_user_data.dart';
import 'package:test/test.dart';

void main() {
  group('ClearUserDataReducer', () {
    test('clears any user data from the app state', () {
      // Setup an initial app state with a user.
      final initialState = AppState.init().rebuild((b) => b
        ..user.replace(User(
            id: 'id',
            displayName: 'name',
            photoURL: 'url',
            email: 'email',
            providers: BuiltList<ProviderInfo>())));

      // Create the reducer.
      final rut = ClearUserDataReducer();

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(initialState, ClearUserData());

      // Check that the new state has null for the user.
      expect(newState.user, null);
    });

    test('resets list of PageData objects', () {
      // Setup an initial app state with EmailAuthPageData in pageData list
      final initialState = AppState.init().rebuild(
        (b) => b..pagesData = ListBuilder(<PageData>[EmailAuthPageData()]),
      );

      // Create the reducer.
      final rut = ClearUserDataReducer();

      // Invoke the reducer to get a new state.
      final newState = rut.reducer(initialState, ClearUserData());

      // Check that the new state has the initial pageData list
      expect(newState.pagesData, AppState.init().pagesData);
    });
  });
}
