import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';
import 'package:scoreboard_private/firestore_private.dart';
import 'package:scoreboard_public/scoreboard_public.dart';

part './scoreboard_event.dart';
part './scoreboard_state.dart';

typedef ScoreboardBloc = Bloc<ScoreboardEvent, ScoreboardState>;

class ConcreteScoreboardBloc extends Bloc<ScoreboardEvent, ScoreboardState> {
  ConcreteScoreboardBloc(FirestoreRepository firestore)
      : _firestore = firestore,
        super(const ScoreboardState()) {
    on<CreateUserGameEvent>(_createUserGame);
    on<FetchGameEvent>(_emitFetchedGame);

    on<UpdateP1ScoreEvent>(_emitP1ScoreChanged);
    on<UpdateP2ScoreEvent>(_emitP2ScoreChanged);

    on<UpdateP1NameEvent>(_emitP1NameChanged);
    on<UpdateP2NameEvent>(_emitP2NameChanged);
  }
  final FirestoreRepository _firestore;

  void _createUserGame(CreateUserGameEvent event, Emitter<ScoreboardState> emit) async {
    try {
      await _firestore.createUserGame(event.pin);
      emit(const ScoreboardState(status: Status.success));
    } catch (e) {
      emit(const ScoreboardState(status: Status.unknown));
    }
  }

  void _emitFetchedGame(FetchGameEvent event, Emitter<ScoreboardState> emit) async {
    try {
      final fetchedGame = await _firestore.fetchGame(event.pin);
      emit(ScoreboardState(status: Status.success, gameResult: Success(fetchedGame)));
    } catch (e) {
      emit(ScoreboardState(status: Status.unknown, gameResult: Failure('Failed to fetch game: $e')));
    }
  }

  void _emitP1ScoreChanged(UpdateP1ScoreEvent event, Emitter<ScoreboardState> emit) async {
    try {
      await _firestore.updateScore(playerPosition: 1, score: event.score);
      emit(const ScoreboardState(status: Status.success));
    } catch (e) {
      emit(ScoreboardState(status: Status.unknown, gameResult: Failure('Failed to update p1Score')));
    }
  }

  void _emitP2ScoreChanged(UpdateP2ScoreEvent event, Emitter<ScoreboardState> emit) async {
    try {
      await _firestore.updateScore(playerPosition: 2, score: event.score);
      emit(const ScoreboardState(status: Status.success));
    } catch (e) {
      emit(ScoreboardState(status: Status.unknown, gameResult: Failure('Failed to update p2Score')));
    }
  }

  void _emitP1NameChanged(UpdateP1NameEvent event, Emitter<ScoreboardState> emit) async {
    try {
      await _firestore.updateName(playerPosition: 1, name: event.name);
      emit(const ScoreboardState(status: Status.success));
    } catch (e) {
      emit(ScoreboardState(status: Status.unknown, gameResult: Failure('Failed to update p1Name')));
    }
  }

  void _emitP2NameChanged(UpdateP2NameEvent event, Emitter<ScoreboardState> emit) async {
    try {
      await _firestore.updateName(playerPosition: 2, name: event.name);
      emit(const ScoreboardState(status: Status.success));
    } catch (e) {
      emit(ScoreboardState(status: Status.unknown, gameResult: Failure('Failed to update p2Name')));
    }
  }
}
