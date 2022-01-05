import 'package:flutter_test/flutter_test.dart';
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
}
