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
    on<GetCurrentUserEvent>(_getCurrentUser);
  }

  void _getCurrentUser(GetCurrentUserEvent event, Emitter<AuthState> emit) {
    try {
      emit(AuthState.authenticated(_authentication.currentUser));
    } catch (e) {
      emit(const AuthState.unauthenticated());
    }
  }

  final Authentication _authentication;
}
