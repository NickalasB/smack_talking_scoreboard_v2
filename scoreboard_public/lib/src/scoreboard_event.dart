part of './scoreboard_bloc.dart';

@immutable
abstract class ScoreboardEvent extends Equatable {
  const ScoreboardEvent();

  @override
  List<Object?> get props => [];
}

class CreateUserGameEvent extends ScoreboardEvent {
  const CreateUserGameEvent(this.pin);

  final int pin;

  @override
  List<Object?> get props => [pin];
}

class UpdateP1ScoreEvent extends ScoreboardEvent {
  const UpdateP1ScoreEvent(this.score);

  final int score;

  @override
  List<Object?> get props => [score];
}
