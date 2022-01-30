import 'package:flutter_test/flutter_test.dart';
import 'package:scoreboard_public/scoreboard_public.dart';

void main() {
  group('ScoreboardEvents', () {
    test('CreateUserGame should have value-type equality', () {
      expect(const CreateUserGameEvent(1), equals(const CreateUserGameEvent(1)));
      expect(const CreateUserGameEvent(1), isNot(equals(const CreateUserGameEvent(2))));
    });

    test('FetchGameEvent should have value-type equality', () {
      expect(const FetchGameEvent(pin: 1), equals(const FetchGameEvent(pin: 1)));
      expect(const FetchGameEvent(pin: 1), isNot(equals(const FetchGameEvent(pin: 2))));
    });

    test('UpdateP1ScoreEvent should have value-type equality', () {
      expect(const UpdateP1ScoreEvent(1), equals(const UpdateP1ScoreEvent(1)));
      expect(const UpdateP1ScoreEvent(1), isNot(equals(const UpdateP1ScoreEvent(2))));
    });

    test('UpdateP2ScoreEvent should have value-type equality', () {
      expect(const UpdateP2ScoreEvent(1), equals(const UpdateP2ScoreEvent(1)));
      expect(const UpdateP2ScoreEvent(1), isNot(equals(const UpdateP2ScoreEvent(2))));
    });

    test('UpdateP1NameEvent should have value-type equality', () {
      expect(const UpdateP1NameEvent('Bill'), equals(const UpdateP1NameEvent('Bill')));
      expect(const UpdateP1NameEvent('Bill'), isNot(equals(const UpdateP1NameEvent('Phil'))));
    });

    test('UpdateP2NameEvent should have value-type equality', () {
      expect(const UpdateP2NameEvent('Bill'), equals(const UpdateP2NameEvent('Bill')));
      expect(const UpdateP2NameEvent('Bill'), isNot(equals(const UpdateP2NameEvent('Phil'))));
    });
  });
}
