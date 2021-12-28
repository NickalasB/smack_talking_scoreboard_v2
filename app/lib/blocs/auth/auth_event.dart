part of 'auth_bloc.dart';

@immutable
class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class GetCurrentUserEvent extends AuthEvent {
  const GetCurrentUserEvent();
}

class LogInWithEmailAndPasswordEvent extends AuthEvent {
  const LogInWithEmailAndPasswordEvent({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class LogInWithGoogleEvent extends AuthEvent {
  const LogInWithGoogleEvent();
}

class LogOutEvent extends AuthEvent {
  const LogOutEvent();
}

class SignUpEvent extends AuthEvent {
  const SignUpEvent({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class UserStreamEvent {
  const UserStreamEvent();
}
