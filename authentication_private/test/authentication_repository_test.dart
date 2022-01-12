// ignore_for_file: prefer_const_constructors
import 'package:authentication_private/authentication_private.dart';
import 'package:authentication_public/src/scoreboard_user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';

import 'test_helpers.dart';

const _mockFirebaseUserUid = 'mock-uid';
const _mockFirebaseUserEmail = 'mock-email';

mixin LegacyEquality {
  @override
  bool operator ==(dynamic other) => false;

  @override
  int get hashCode => 0;
}

class MockFirebaseAuth extends Mock implements firebase_auth.FirebaseAuth {}

class MockFirebaseUser extends Mock implements firebase_auth.User {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock with LegacyEquality implements GoogleSignInAccount {}

class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

class MockUserCredential extends Mock implements firebase_auth.UserCredential {}

class FakeAuthCredential extends Fake implements firebase_auth.AuthCredential {}

class FakeAuthProvider extends Fake implements AuthProvider {}

void main() {
  setUpFirebaseTests();

  const email = 'test@gmail.com';
  const password = 't0ps3cret42';
  const user = ScoreboardUser(
    id: _mockFirebaseUserUid,
    email: _mockFirebaseUserEmail,
  );

  group('AuthenticationRepository', () {
    late firebase_auth.FirebaseAuth firebaseAuth;
    late GoogleSignIn googleSignIn;
    late AuthenticationRepository authenticationRepository;

    setUpAll(() {
      registerFallbackValue(FakeAuthCredential());
      registerFallbackValue(FakeAuthProvider());
    });

    setUp(() {
      firebaseAuth = MockFirebaseAuth();
      googleSignIn = MockGoogleSignIn();
      authenticationRepository = AuthenticationRepository(
        firebaseAuth: firebaseAuth,
        googleSignIn: googleSignIn,
      );
    });

    test('creates FirebaseAuth instance internally when not injected', () {
      expect(() => AuthenticationRepository(), isNot(throwsException));
    });

    group('signUp', () {
      setUp(() {
        when(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) => Future.value(MockUserCredential()));
      });

      test('calls createUserWithEmailAndPassword', () async {
        await authenticationRepository.signUp(email: email, password: password);
        verify(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).called(1);
      });

      test('succeeds when createUserWithEmailAndPassword succeeds', () async {
        expect(
          authenticationRepository.signUp(email: email, password: password),
          completes,
        );
      });

      test(
          'throws SignUpWithEmailAndPasswordFailure '
          'when createUserWithEmailAndPassword throws', () async {
        when(
          () => firebaseAuth.createUserWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(Exception());
        expect(
          authenticationRepository.signUp(email: email, password: password),
          throwsA(isA<SignUpWithEmailAndPasswordFailure>()),
        );
      });
    });

    group('logInWithGoogle', () {
      const accessToken = 'access-token';
      const idToken = 'id-token';

      setUp(() {
        final googleSignInAuthentication = MockGoogleSignInAuthentication();
        final googleSignInAccount = MockGoogleSignInAccount();
        when(() => googleSignInAuthentication.accessToken).thenReturn(accessToken);
        when(() => googleSignInAuthentication.idToken).thenReturn(idToken);
        when(() => googleSignInAccount.authentication).thenAnswer((_) async => googleSignInAuthentication);
        when(() => googleSignIn.signIn()).thenAnswer((_) async => googleSignInAccount);
        when(() => firebaseAuth.signInWithCredential(any())).thenAnswer((_) => Future.value(MockUserCredential()));
        when(() => firebaseAuth.signInWithPopup(any())).thenAnswer((_) => Future.value(MockUserCredential()));
      });

      test('calls signIn authentication, and signInWithCredential', () async {
        await authenticationRepository.logInWithGoogle();
        verify(() => googleSignIn.signIn()).called(1);
        verify(() => firebaseAuth.signInWithCredential(any())).called(1);
      });

      test(
          'throws LogInWithGoogleFailure and calls signIn authentication, and '
          'signInWithPopup when authCredential is null and kIsWeb is true', () async {
        authenticationRepository.isWeb = true;
        await expectLater(
          () => authenticationRepository.logInWithGoogle(),
          throwsA(isA<LogInWithGoogleFailure>()),
        );
        verifyNever(() => googleSignIn.signIn());
        verify(() => firebaseAuth.signInWithPopup(any())).called(1);
      });

      test(
          'sucessfully calls signIn authentication, and '
          'signInWithPopup when authCredential is not null and kIsWeb is true', () async {
        final credential = MockUserCredential();
        when(() => firebaseAuth.signInWithPopup(any())).thenAnswer((_) async => credential);
        when(() => credential.credential).thenReturn(FakeAuthCredential());
        authenticationRepository.isWeb = true;
        await expectLater(
          authenticationRepository.logInWithGoogle(),
          completes,
        );
        verifyNever(() => googleSignIn.signIn());
        verify(() => firebaseAuth.signInWithPopup(any())).called(1);
      });

      test('succeeds when signIn succeeds', () {
        expect(authenticationRepository.logInWithGoogle(), completes);
      });

      test('throws LogInWithGoogleFailure when exception occurs', () async {
        when(() => firebaseAuth.signInWithCredential(any())).thenThrow(Exception());
        expect(
          authenticationRepository.logInWithGoogle(),
          throwsA(isA<LogInWithGoogleFailure>()),
        );
      });
    });

    // group('logInWithEmailAndPassword', () {
    //   test('should log in with logInWithEmailAndPassword', () async {
    //     final auth = MockFirebaseAuth(
    //       mockUser: MockUser(uid: '123', email: 'anything@test.com', displayName: 'FakeUser'),
    //     );
    //
    //     final repository = AuthenticationRepository(
    //       firebaseAuth: auth,
    //     );
    //
    //     await repository.logInWithEmailAndPassword(email: 'anything@test.com', password: 'password');
    //     await whenEmitsFirstNonEmptyUser(repository);
    //     thenScoreboardUserHas(repository.currentUser, id: '123', email: 'anything@test.com', name: 'FakeUser');
    //   });
    //
    //   test('should throw LogInWithEmailAndPasswordFailure when logInWithEmailAndPassword fails', () async {
    //     // TODO(me): figure out best way to mock error cases
    //   });
    // });

    // group('logOut', () {
    //   test(
    //     'Should logOut',
    //     () async {
    //       // TODO(me): MockGoogleSignIn() doesn't implement the ability to fake googleSignin.signOut so this test fails
    //       final auth = MockFirebaseAuth(
    //           signedIn: true, mockUser: MockUser(uid: '123', email: 'anything@test.com', displayName: 'FakeUser'));
    //
    //       final repository = AuthenticationRepository(
    //         firebaseAuth: auth,
    //         googleSignIn: MockGoogleSignIn(),
    //       );
    //       await repository.logInWithEmailAndPassword(email: 'anything@test.com', password: 'password');
    //       await whenEmitsFirstNonEmptyUser(repository);
    //
    //       expect(repository.cachedUser, isNot(null));
    //       await repository.logOut();
    //       expect(repository.cachedUser, isNull);
    //
    //       thenScoreboardUserHas(repository.currentUser, id: '', email: null, name: null);
    //     },
    //     skip: true,
    //   );
    // });

    group('user', () {});

    group('currentUser', () {});

    test('ToUser', () {
      final firebaseUser = MockUser(uid: '123', email: 'anything@test.com', displayName: 'FakeUser');
      final scoreboardUser = ScoreboardUser(id: '123', email: 'anything@test.com', name: 'FakeUser');
      expect(firebaseUser.toUser, scoreboardUser);
    });
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
