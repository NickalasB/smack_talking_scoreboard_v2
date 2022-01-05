import 'package:authentication_public/authentication_public.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'auth_event.dart';
part 'auth_state.dart';

typedef AuthBloc = Bloc<AuthEvent, AuthState>;

class ConcreteAuthBloc extends Bloc<AuthEvent, AuthState> {
  ConcreteAuthBloc(Authentication authentication)
      : _authentication = authentication,
        super(const AuthState.unauthenticated()) {
    on<SignUpEvent>(_signUp);
    on<GetCurrentUserEvent>(_getCurrentUser);
    on<LogInWithEmailAndPasswordEvent>(_logInWithEmailAndPassword);
  }

  void _signUp(SignUpEvent event, Emitter<AuthState> emit) async {
    try {
      _authentication.signUp(email: event.email, password: event.password);
      final user = await _authentication.user.first;
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(const AuthState.unauthenticated());
    }
  }

  void _getCurrentUser(GetCurrentUserEvent event, Emitter<AuthState> emit) {
    try {
      emit(AuthState.authenticated(_authentication.currentUser));
    } catch (e) {
      emit(const AuthState.unauthenticated());
    }
  }

  void _logInWithEmailAndPassword(LogInWithEmailAndPasswordEvent event, Emitter<AuthState> emit) {
    try {
      _authentication.logInWithEmailAndPassword(email: event.email, password: event.password);
      emit(AuthState.authenticated(_authentication.currentUser));
    } catch (e) {
      emit(const AuthState.unauthenticated());
    }
  }

  final Authentication _authentication;
}
