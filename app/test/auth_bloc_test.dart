import 'package:async/async.dart';
import 'package:authentication_public/authentication_public.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then/given_when_then.dart';
import 'package:smack_talking_scoreboard_v2/blocs/auth/auth_bloc.dart';

void main() {
  group('AuthEvents', () {
    test('LogInWithEmailAndPasswordEvent should have value-type equality', () {
      expect(
          const LogInWithEmailAndPasswordEvent(password: '123', email: 'test@test.com'),
          equals(
            const LogInWithEmailAndPasswordEvent(password: '123', email: 'test@test.com'),
          ));
      expect(
          const LogInWithEmailAndPasswordEvent(password: '321', email: 'test@test.com'),
          isNot(
            equals(
              const LogInWithEmailAndPasswordEvent(password: '123', email: 'test@test.com'),
            ),
          ));

      expect(
          const LogInWithEmailAndPasswordEvent(password: '123', email: 'test2@test.com'),
          isNot(
            equals(
              const LogInWithEmailAndPasswordEvent(password: '123', email: 'test@test.com'),
            ),
          ));
    });

    test('SignUpEvent should have value-type equality', () {
      expect(
          const SignUpEvent(password: '123', email: 'test@test.com'),
          equals(
            const SignUpEvent(password: '123', email: 'test@test.com'),
          ));
      expect(
          const SignUpEvent(password: '321', email: 'test@test.com'),
          isNot(
            equals(
              const SignUpEvent(password: '123', email: 'test@test.com'),
            ),
          ));

      expect(
          const SignUpEvent(password: '123', email: 'test2@test.com'),
          isNot(
            equals(
              const SignUpEvent(password: '123', email: 'test@test.com'),
            ),
          ));
    });
  });

  group('AuthState', () {
    const user1 = ScoreboardUser.empty;
    const user2 = ScoreboardUser(id: '123');

    test('AuthState should have value-type equality', () {
      expect(
        const AuthState.authenticated(user1),
        equals(
          const AuthState.authenticated(user1),
        ),
      );
      expect(
        const AuthState.authenticated(user1),
        isNot(equals(
          const AuthState.authenticated(user2),
        )),
      );
      expect(
        const AuthState.unauthenticated(),
        equals(
          const AuthState.unauthenticated(),
        ),
      );
      expect(
        const AuthState.authenticated(user1),
        isNot(equals(
          const AuthState.unauthenticated(),
        )),
      );
    });
  });

  group('AuthBloc', () {
    test('Initial state should be unauthenticated', harness((given, when, then) async {
      expect(
        given.harness.authBloc.state,
        equals(const AuthState.unauthenticated()),
      );
    }));

    test('Should emit authenticated current user when GetCurrentUserEvent successfully added',
        harness((given, when, then) async {
      const fakeUser = ScoreboardUser(id: '1234');

      given.fakeUser(fakeUser);
      await when.add(const GetCurrentUserEvent());
      expect(
        given.harness.authBloc.state,
        equals(const AuthState.authenticated(fakeUser)),
      );
    }));
  });
}

class _Harness {
  late AuthBloc authBloc;
  late Authentication fakeAuthentication;
  ScoreboardUser fakeCurrentUser = ScoreboardUser.empty;
  late StreamQueue<AuthState> stateQueue;
}

Future<void> Function() harness(UnitTestHarnessCallback<_Harness> callback) {
  final harness = _Harness();
  harness.fakeAuthentication = FakeAuthentication();

  harness.authBloc = ConcreteAuthBloc(harness.fakeAuthentication);

  harness.stateQueue = StreamQueue<AuthState>(harness.authBloc.stream);

  return () => givenWhenThenUnitTest(harness, callback);
}

extension on UnitTestGiven<_Harness> {
  void fakeUser(ScoreboardUser user) {
    FakeAuthentication.fakeCurrentUser = user;
  }
}

extension on UnitTestWhen<_Harness> {
  Future<void> add(AuthEvent event) async {
    this.harness.authBloc.add(event);
    await tick();
  }

  Future<void> waitNextState() => this.harness.stateQueue.next;
}

extension on UnitTestThen<_Harness> {
  AuthState get state => this.harness.authBloc.state;
}

Future<void> tick() => Future.microtask(() {});

class FakeAuthentication extends Authentication {
  static ScoreboardUser fakeCurrentUser = ScoreboardUser.empty;

  @override
  ScoreboardUser get currentUser => fakeCurrentUser;

  @override
  Future<void> logInWithEmailAndPassword({required String email, required String password}) async {}

  @override
  Future<void> logInWithGoogle() async {}

  @override
  Future<void> logOut() async {}

  @override
  Future<void> signUp({required String email, required String password}) async {}

  @override
  Stream<ScoreboardUser> get user => throw UnimplementedError();
}
