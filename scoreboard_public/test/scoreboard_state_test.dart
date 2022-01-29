import 'package:flutter_test/flutter_test.dart';
import 'package:result_type/result_type.dart';
import 'package:scoreboard_public/scoreboard_public.dart';
import 'package:scoreboard_public/src/scoreboard_bloc.dart';

void main() {
  group('ScoreboardState', () {
    test('ScoreboardState should have value-type equality', () {
      expect(
        ScoreboardState(status: Status.loading, scoreResult: Success(1)),
        equals(ScoreboardState(status: Status.loading, scoreResult: Success(1))),
      );

      //result
      expect(
        ScoreboardState(scoreResult: Success(1)),
        isNot(equals(ScoreboardState(scoreResult: Success(2)))),
      );

      //status
      expect(
        const ScoreboardState(status: Status.loading),
        isNot(equals(const ScoreboardState(status: Status.loaded))),
      );
    });
  });
}
