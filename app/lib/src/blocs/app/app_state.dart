part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = ScoreboardUser.anonymous,
  });

  const AppState.authenticated(ScoreboardUser user) : this._(status: AppStatus.authenticated, user: user);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final ScoreboardUser user;

  @override
  List<Object> get props => [status, user];
}
