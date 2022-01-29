import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoreboard_public/scoreboard_public.dart';

class FirestoreRepository implements ClientFirestoreRepository {
  FirestoreRepository({
    FirebaseFirestore? firebaseFirestore,
    required this.userEmail,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firebaseFirestore;
  final String userEmail;

  @visibleForTesting
  CollectionReference<Game> get userGamesCollectionRef {
    return _firebaseFirestore.collection('users').doc(userEmail).collection('games').withConverter<Game>(
          fromFirestore: (snapshot, _) => Game.fromJson(snapshot.data()!),
          toFirestore: (game, _) => game.toJson(),
        );
  }

  @visibleForTesting
  DocumentReference<Game>? gameRef;

  @override
  Future<void> createUserGame(int pin) async {
    gameRef = userGamesCollectionRef.doc(pin.toString());
    gameRef!.set(const Game());
  }

  @override
  Future<void> updateScore({required int playerPosition, required int score}) {
    return gameRef!.update({'p${playerPosition}Score': score});
  }

  @override
  Future<void> updateName({required int playerPosition, required String name}) {
    return gameRef!.update({'p${playerPosition}Name': name});
  }

  @override
  Future<Game?> fetchGame(int pin) async => (await userGamesCollectionRef.doc(pin.toString()).get().then((value) {
        gameRef = userGamesCollectionRef.doc(pin.toString());
        return value.data();
      }));
}
