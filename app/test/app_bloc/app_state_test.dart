// ignore_for_file: prefer_const_constructors
import 'package:authentication_public/authentication_public.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smack_talking_scoreboard_v2/src/blocs/app/app_bloc.dart';

class MockUser extends Mock implements ScoreboardUser {}

void main() {
  group('AppState', () {
    group('unauthenticated', () {
      test('has correct status', () {
        final state = AppState.unauthenticated();
        expect(state.status, AppStatus.unauthenticated);
        expect(state.user, ScoreboardUser.anonymous);
      });
    });

    group('authenticated', () {
      test('has correct status', () {
        final user = MockUser();
        final state = AppState.authenticated(user);
        expect(state.status, AppStatus.authenticated);
        expect(state.user, user);
      });
    });
  });
}
