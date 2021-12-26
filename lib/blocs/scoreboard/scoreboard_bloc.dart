import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

part 'scoreboard_event.dart';
part 'scoreboard_state.dart';

typedef ScoreboardBloc = Bloc<ScoreboardEvent, ScoreboardState>;

class ConcreteScoreboardBloc extends Bloc<ScoreboardEvent, ScoreboardState> {
  ConcreteScoreboardBloc(FirebaseFirestore firestore) : super(const ScoreboardState()) {
    on<UpdateScoreEvent>((event, emit) => _emitScoreChanged(event, emit, firestore));
  }

  _emitScoreChanged(UpdateScoreEvent event, Emitter<ScoreboardState> emit, FirebaseFirestore firestore) async {
    emit(ScoreboardState(status: Status.loaded, scoreResult: Success(event.score)));
  }
}
