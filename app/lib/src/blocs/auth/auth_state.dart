part of 'auth_bloc.dart';

enum AuthStatus {
  authenticated,
  unauthenticated,
}

@immutable
class AuthState extends Equatable {
  const AuthState._({required this.status, this.user = ScoreboardUser.empty});

  const AuthState.authenticated(ScoreboardUser user) : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final ScoreboardUser user;

  @override
  List<Object?> get props => [status, user];
}
