import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

part 'scoreboard_event.dart';
part 'scoreboard_state.dart';

class ScoreboardBloc extends Bloc<ScoreboardEvent, ScoreboardState> {
  ScoreboardBloc() : super(const ScoreboardState.initial()) {
    on<UpdateScoreEvent>(_emitScoreChanged);
  }

  _emitScoreChanged(UpdateScoreEvent event, Emitter<ScoreboardState> emit) {
    emit(ScoreboardState.loaded(Success(event.score)));
  }
}
