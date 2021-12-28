import 'package:authentication_private/authentication_private.dart';
import 'package:authentication_private/src/scoreboard_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  test('Should return ScoreboardUser when getUser called after signing in', () async {
    final auth = MockFirebaseAuth(
      mockUser: MockUser(uid: '123', email: 'anything@test.com', displayName: 'FakeUser'),
    );

    final repository = AuthenticationRepository(
      firebaseAuth: auth,
    );
    await repository.logInWithEmailAndPassword(email: 'anything@test.com', password: 'password');

    expect(
        repository.user,
        emitsInOrder([
          isA<ScoreboardUser>().having((p0) => p0.id, 'id', ''),
          isA<ScoreboardUser>()
              .having((p0) => p0.id, 'id', '123')
              .having((p0) => p0.email, 'email', 'anything@test.com')
              .having((p0) => p0.name, 'name', 'FakeUser')
        ]));
  });

  test('Should return Empty ScoreboardUser if cachedUser is null when get CurrentUser called', () {
    final repository = AuthenticationRepository(firebaseAuth: MockFirebaseAuth());
    expect(repository.currentUser, ScoreboardUser.empty);
  });

  test('Should return cashed ScoreboardUser if cachedUser is NOT null when get CurrentUser called', () async {
    final auth = MockFirebaseAuth(
      mockUser: MockUser(uid: '123', email: 'anything@test.com', displayName: 'FakeUser'),
    );

    final repository = AuthenticationRepository(
      firebaseAuth: auth,
    );

    await repository.logInWithEmailAndPassword(email: 'anything@test.com', password: 'password');
    await whenEmitsFirstNonEmptyUser(repository);
    thenScoreboardUserHas(repository.currentUser!, id: '123', email: 'anything@test.com', name: 'FakeUser');
  });

  group('signUp', () {
    test('Should signUp', () async {
      // TODO(me): createUserWithEmailAndPassword is not faked MockFirebaseAuth https://github.com/atn832/firebase_auth_mocks/issues/28
    });
  });

  group('logInWithGoogle', () {
    test('should log in with google', () async {
      final auth = MockFirebaseAuth(
        mockUser: MockUser(uid: '123', email: 'anything@test.com', displayName: 'FakeUser'),
      );

      final repository = AuthenticationRepository(
        firebaseAuth: auth,
        googleSignIn: MockGoogleSignIn(),
      );

      await repository.logInWithGoogle();
      await whenEmitsFirstNonEmptyUser(repository);
      thenScoreboardUserHas(repository.currentUser!, id: '123', email: 'anything@test.com', name: 'FakeUser');
    });
  });

  group('logInWithEmailAndPassword', () {
    test('should log in with logInWithEmailAndPassword', () async {
      final auth = MockFirebaseAuth(
        mockUser: MockUser(uid: '123', email: 'anything@test.com', displayName: 'FakeUser'),
      );

      final repository = AuthenticationRepository(
        firebaseAuth: auth,
      );

      await repository.logInWithEmailAndPassword(email: 'anything@test.com', password: 'password');
      await whenEmitsFirstNonEmptyUser(repository);
      thenScoreboardUserHas(repository.currentUser!, id: '123', email: 'anything@test.com', name: 'FakeUser');
    });

    test('should throw LogInWithEmailAndPasswordFailure when logInWithEmailAndPassword fails', () async {
      // TODO(me): figure out best way to mock error cases
    });
  });

  group('logOut', () {
    test(
      'Should logOut',
      () async {
        // TODO(me): MockGoogleSignIn() doesn't implement the ability to fake googleSignin.signOut so this test fails
        final auth = MockFirebaseAuth(
            signedIn: true, mockUser: MockUser(uid: '123', email: 'anything@test.com', displayName: 'FakeUser'));

        final repository = AuthenticationRepository(
          firebaseAuth: auth,
          googleSignIn: MockGoogleSignIn(),
        );
        await repository.logInWithEmailAndPassword(email: 'anything@test.com', password: 'password');
        await whenEmitsFirstNonEmptyUser(repository);

        expect(repository.cachedUser, isNot(null));
        await repository.logOut();
        expect(repository.cachedUser, isNull);

        thenScoreboardUserHas(repository.currentUser!, id: '', email: null, name: null);
      },
      skip: true,
    );
  });
}

Future<void> whenEmitsFirstNonEmptyUser(AuthenticationRepository repository) async {
  await repository.user.any((element) => element.id != '');
}

void thenScoreboardUserHas(ScoreboardUser user, {required String id, String? email, String? name}) {
  expect(
    user,
    const TypeMatcher<ScoreboardUser>()
        .having((p0) => p0.id, 'id', id)
        .having((p0) => p0.email, 'email', email)
        .having((p0) => p0.name, 'name', name),
  );
}

class FakeAuthCredential implements AuthCredential {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
