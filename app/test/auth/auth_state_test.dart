import 'package:authentication_public/authentication_public.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v2/blocs/auth/auth_bloc.dart';

void main() {
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
}
