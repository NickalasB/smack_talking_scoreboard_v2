import 'package:flutter_test/flutter_test.dart';
import 'package:scoreboard_public/scoreboard_public.dart';

void main() {
  group('ScoreboardEvents', () {
    test('UpdateP1ScoreEvent should have value-type equality', () {
      expect(const UpdateP1ScoreEvent(1), equals(const UpdateP1ScoreEvent(1)));
      expect(const UpdateP1ScoreEvent(1), isNot(equals(const UpdateP1ScoreEvent(2))));
    });

    test('CreateUserGame should have value-type equality', () {
      expect(const CreateUserGameEvent(1), equals(const CreateUserGameEvent(1)));
      expect(const CreateUserGameEvent(1), isNot(equals(const CreateUserGameEvent(2))));
    });
  });
}
