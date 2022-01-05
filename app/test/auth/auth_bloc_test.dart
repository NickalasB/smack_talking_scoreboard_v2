import 'package:authentication_public/authentication_public.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v2/blocs/auth/auth_bloc.dart';

import '../fake_authentication.dart';
import '../test_helpers.dart';

void main() {
  setUpFirebaseTests();

  group('AuthBloc', () {
    final authBloc = MockAuthBloc();

    test('Initial state should be unauthenticated', () async {
      whenListen(
        authBloc,
        Stream.fromIterable([
          const AuthState.unauthenticated(),
          const AuthState.authenticated(ScoreboardUser(id: '123')),
        ]),
        initialState: const AuthState.unauthenticated(),
      );

      expect(authBloc.state, equals(const AuthState.unauthenticated()));
    });

    test('Should emit authenticatedUser from stream', () async {
      whenListen(
        authBloc,
        Stream.fromIterable([
          const AuthState.unauthenticated(),
          const AuthState.authenticated(ScoreboardUser(id: '123')),
        ]),
        initialState: const AuthState.unauthenticated(),
      );

      await expectLater(
          authBloc.stream,
          emitsInOrder(<AuthState>[
            const AuthState.unauthenticated(),
            const AuthState.authenticated(ScoreboardUser(id: '123'))
          ]));

      expect(authBloc.state, equals(const AuthState.authenticated(ScoreboardUser(id: '123'))));
    });

    blocTest(
      'Should emit authenticated  user when SignUpEvent successfully added',
      setUp: () => FakeAuthentication.fakeCurrentUser = const ScoreboardUser(id: '123', email: 'test@test.com'),
      build: () => ConcreteAuthBloc(FakeAuthentication()),
      act: (AuthBloc bloc) => bloc.add(const SignUpEvent(email: 'test@test.com', password: '123')),
      expect: () => [const AuthState.authenticated(ScoreboardUser(id: '123', email: 'test@test.com'))],
    );

    blocTest(
      'Should emit authenticated current user when GetCurrentUserEvent successfully added',
      setUp: () => FakeAuthentication.fakeCurrentUser = const ScoreboardUser(id: '123', email: 'test@test.com'),
      build: () => ConcreteAuthBloc(FakeAuthentication()),
      act: (AuthBloc bloc) => bloc.add(const GetCurrentUserEvent()),
      expect: () => [const AuthState.authenticated(ScoreboardUser(id: '123', email: 'test@test.com'))],
    );

    blocTest(
      'Should emit authenticated current user when LogInWithEmailAndPasswordEvent successfully added',
      setUp: () => FakeAuthentication.fakeCurrentUser = const ScoreboardUser(id: '123', email: 'test@test.com'),
      build: () => ConcreteAuthBloc(FakeAuthentication()),
      act: (AuthBloc bloc) => bloc.add(const LogInWithEmailAndPasswordEvent(email: 'test@test.com', password: '555')),
      expect: () => [const AuthState.authenticated(ScoreboardUser(id: '123', email: 'test@test.com'))],
    );
  });
}

class MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}
