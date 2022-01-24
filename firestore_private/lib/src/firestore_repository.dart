import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_public/firestore_public.dart';
import 'package:flutter/cupertino.dart';

class FirestoreRepository implements Firestore {
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
          toFirestore: (model, _) => model.toJson(),
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
  Future<void> updateP1Score(int score) => gameRef!.update({'p1Score': score});

  @override
  Future<void> updateP2Score(int score) => gameRef!.update({'p2Score': score});

  @override
  Future<void> updateP1Name(String name) => gameRef!.update({'p1Name': name});

  @override
  Future<void> updateP2Name(String name) => gameRef!.update({'p2Name': name});

  @override
  Future<Game?> fetchGame(int pin) async => (await userGamesCollectionRef.doc(pin.toString()).get().then((value) {
        gameRef = userGamesCollectionRef.doc(pin.toString());
        return value.data();
      }));
}
