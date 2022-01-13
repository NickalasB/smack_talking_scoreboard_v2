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
  ConcreteScoreboardBloc(FirebaseFirestore firestore)
      : _firestore = firestore,
        super(const ScoreboardState()) {
    on<UpdateScoreEvent>(_emitScoreChanged);
  }
  final FirebaseFirestore _firestore;

  void _emitScoreChanged(UpdateScoreEvent event, Emitter<ScoreboardState> emit) async {
    emit(ScoreboardState(status: Status.loaded, scoreResult: Success(event.score)));
  }
}
