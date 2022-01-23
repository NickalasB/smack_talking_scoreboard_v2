import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
class Game extends Equatable {
  const Game({
    this.p1Name = 'Player 1',
    this.p2Name = 'Player 2',
    this.p1Score = 0,
    this.p2Score = 0,
  });

  final String p1Name;
  final String p2Name;
  final int p1Score;
  final int p2Score;

  Game.fromJson(Map<String, dynamic> json)
      : p1Name = json['p1Name'],
        p2Name = json['p2Name'],
        p1Score = json['p1Score'],
        p2Score = json['p2Score'];

  Map<String, dynamic> toJson() => {
        'p1Name': p1Name,
        'p2Name': p2Name,
        'p1Score': p1Score,
        'p2Score': p2Score,
      };

  @override
  List<Object?> get props => [
        p1Name,
        p2Name,
        p1Score,
        p2Score,
      ];
}
