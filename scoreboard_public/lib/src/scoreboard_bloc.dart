import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';
import 'package:scoreboard_private/firestore_private.dart';

part './scoreboard_event.dart';
part './scoreboard_state.dart';

typedef ScoreboardBloc = Bloc<ScoreboardEvent, ScoreboardState>;

class ConcreteScoreboardBloc extends Bloc<ScoreboardEvent, ScoreboardState> {
  ConcreteScoreboardBloc(FirestoreRepository firestore)
      : _firestore = firestore,
        super(const ScoreboardState()) {
    on<CreateUserGameEvent>(_createUserGame);
    on<UpdateP1ScoreEvent>(_emitScoreChanged);
  }
  final FirestoreRepository _firestore;

  void _createUserGame(CreateUserGameEvent event, Emitter<ScoreboardState> emit) async {
    try {
      _firestore.createUserGame(event.pin);
      emit(const ScoreboardState(status: Status.loaded));
    } catch (e) {
      emit(const ScoreboardState(status: Status.unknown));
    }
  }

  void _emitScoreChanged(UpdateP1ScoreEvent event, Emitter<ScoreboardState> emit) async {
    try {
      _firestore.updateScore(playerPosition: 1, score: event.score);
      emit(ScoreboardState(status: Status.loaded, scoreResult: Success(event.score)));
    } catch (e) {
      emit(ScoreboardState(status: Status.unknown, scoreResult: Failure('Failed to update p1Score')));
    }
  }
}