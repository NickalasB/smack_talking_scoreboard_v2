import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'auth_event.dart';
part 'auth_state.dart';

typedef AuthBloc = Bloc<AuthEvent, AuthState>;

class ConcreteAuthBloc extends Bloc<AuthEvent, AuthState> {
  ConcreteAuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
