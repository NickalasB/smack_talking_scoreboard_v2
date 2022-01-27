part of './scoreboard_bloc.dart';

enum Status { unknown, loading, loaded }

@immutable
class ScoreboardState extends Equatable {
  const ScoreboardState({this.status = Status.unknown, this.scoreResult});

  int get score => scoreResult?.success ?? 0;

  final Status status;
  final Result<int, Object>? scoreResult;

  @override
  List<Object?> get props => [status, scoreResult];
}
