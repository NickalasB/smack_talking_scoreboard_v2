// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:scoreboard_public/scoreboard_public.dart';

void main() {
  group('Game model tests', () {
    final testGame = Game(
      p1Name: 'Jill',
      p2Name: 'Will',
      p1Score: 1,
      p2Score: 2,
    );

    test('Game should have value-type equality', () {
      expect(testGame, testGame.copyWith());

      expect(testGame, isNot(equals(testGame.copyWith(p1Name: 'Megan'))));
      expect(testGame, isNot(equals(testGame.copyWith(p2Name: 'Billy'))));
      expect(testGame, isNot(equals(testGame.copyWith(p1Score: 3))));
      expect(testGame, isNot(equals(testGame.copyWith(p2Score: 4))));
    });

    test('toJson', () {
      expect(
        testGame.toJson().toString(),
        "{p1Name: Jill, p2Name: Will, p1Score: 1, p2Score: 2}",
      );
    });

    test('fromJson', () {
      expect(
        Game.fromJson(const {
          'p1Name': 'Mike',
          'p2Name': 'Jordan',
          'p1Score': 2,
          'p2Score': 3,
        }),
        Game(
          p1Name: 'Mike',
          p2Name: 'Jordan',
          p1Score: 2,
          p2Score: 3,
        ),
      );
    });
  });
}
