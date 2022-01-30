part of './scoreboard_bloc.dart';

enum Status { unknown, loading, success }

@immutable
class ScoreboardState extends Equatable {
  const ScoreboardState({this.status = Status.unknown, this.gameResult});

  int get p1score => gameResult?.success.p1Score ?? 0;
  String get p1Name => gameResult?.success.p1Name ?? 'Player1';

  final Status status;
  final Result<Game, Object>? gameResult;

  @override
  List<Object?> get props => [status, gameResult];
}
