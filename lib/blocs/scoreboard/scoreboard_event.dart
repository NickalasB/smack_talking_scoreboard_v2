part of 'scoreboard_bloc.dart';

@immutable
abstract class ScoreboardEvent extends Equatable {
  const ScoreboardEvent();

  @override
  List<Object?> get props => [];
}

class UpdateScoreEvent extends ScoreboardEvent {
  const UpdateScoreEvent(this.score);

  final int score;

  @override
  List<Object?> get props => [score];
}
