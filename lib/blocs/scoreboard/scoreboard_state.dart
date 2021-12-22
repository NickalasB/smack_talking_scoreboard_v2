part of 'scoreboard_bloc.dart';

enum Status { unknown, loading, loaded }

@immutable
class ScoreboardState extends Equatable {
  const ScoreboardState._({this.status = Status.unknown, this.scoreResult});

  const ScoreboardState.initial() : this._();
  const ScoreboardState.loading() : this._(status: Status.loading);
  const ScoreboardState.loaded(Result<int, Object>? result) : this._(status: Status.loaded, scoreResult: result);

  int get score => scoreResult?.success ?? 0;

  final Status status;
  final Result<int, Object>? scoreResult;

  @override
  List<Object?> get props => [status, scoreResult];
}
