import 'package:authentication_public/authentication_public.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v2/blocs/app/app_bloc.dart';

import 'fake_authentication.dart';
import 'test_helpers.dart';

void main() {
  setUpFirebaseTests();

  final appBloc = MockAppBloc();

  test('Initial state should be unauthenticated', () async {
    whenListen(
      appBloc,
      Stream.fromIterable([
        const AppState.unauthenticated(),
        const AppState.authenticated(ScoreboardUser(id: '123')),
      ]),
      initialState: const AppState.unauthenticated(),
    );

    expect(appBloc.state, equals(const AppState.unauthenticated()));
  });

  test('Should emit authenticatedUser from stream', () async {
    whenListen(
      appBloc,
      Stream.fromIterable([
        const AppState.unauthenticated(),
        const AppState.authenticated(ScoreboardUser(id: '123')),
      ]),
      initialState: const AppState.unauthenticated(),
    );

    await expectLater(
        appBloc.stream,
        emitsInOrder(
            <AppState>[const AppState.unauthenticated(), const AppState.authenticated(ScoreboardUser(id: '123'))]));

    expect(appBloc.state, equals(const AppState.authenticated(ScoreboardUser(id: '123'))));
  });

  blocTest(
    'Should emit new authenticated user when AppUserChangedEvent successfully added',
    setUp: () => FakeAuthentication.fakeCurrentUser = const ScoreboardUser(id: '123', email: 'test@test.com'),
    build: () => AppBloc(authenticationRepository: FakeAuthentication()),
    act: (AppBloc bloc) => bloc.add(const AppUserChanged(ScoreboardUser(id: '555', email: 'new@test.com'))),
    expect: () => [
      const AppState.authenticated(ScoreboardUser(id: '555', email: 'new@test.com')),
      const AppState.authenticated(ScoreboardUser(id: '123', email: 'test@test.com')),
    ],
  );
}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}
