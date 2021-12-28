import 'package:authentication_private/authentication_private.dart';
import 'package:authentication_private/src/scoreboard_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

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
}

void thenUserHas(User user, {required String id, required String email, required String name}) {
  expect(
    user,
    const TypeMatcher<User>()
        .having((p0) => p0.uid, 'id', id)
        .having((p0) => p0.email, 'email', email)
        .having((p0) => p0.displayName, 'name', name),
  );
}
