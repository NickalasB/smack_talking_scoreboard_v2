// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:result_type/result_type.dart';
import 'package:scoreboard_public/scoreboard_public.dart';
import 'package:scoreboard_public/src/scoreboard_bloc.dart';

void main() {
  group('ScoreboardState', () {
    test('ScoreboardState should have value-type equality', () {
      expect(
        ScoreboardState(status: Status.loading, gameResult: Success(Game().copyWith())),
        equals(ScoreboardState(status: Status.loading, gameResult: Success(Game().copyWith()))),
      );

      //result
      expect(
        ScoreboardState(gameResult: Success(Game().copyWith())),
        isNot(equals(ScoreboardState(gameResult: Success(Game().copyWith(p1Score: 2))))),
      );

      //status
      expect(
        const ScoreboardState(status: Status.loading),
        isNot(equals(const ScoreboardState(status: Status.success))),
      );
    });
  });
}
