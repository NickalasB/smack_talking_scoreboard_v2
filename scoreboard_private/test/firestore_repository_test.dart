import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scoreboard_private/src/firestore_repository.dart';
import 'package:scoreboard_public/scoreboard_public.dart';

import 'fake_firebase.dart';

void main() {
  setUp(() {
    Firebase.delegatePackingProperty = FakeFirebase();
  });

  test('creates Firestore instance internally when not injected', () {
    expect(() => FirestoreRepository(userEmail: 'anything'), isNot(throwsException));
  });

  test('createUserGame should work', () async {
    final fakeFireStore = FakeFirebaseFirestore();
    final repo = FirestoreRepository(
      userEmail: 'test@test.com',
      firebaseFirestore: fakeFireStore,
    );

    expect(repo.createUserGame(123), completes);
  });

  test('deleteUserGame should work', () async {
    final fakeFireStore = FakeFirebaseFirestore();
    final repo = FirestoreRepository(
      userEmail: 'test@test.com',
      firebaseFirestore: fakeFireStore,
    );
    await repo.createUserGame(123);

    expect(repo.deleteUserGame(555), completes);
  });

  test('deleteUserGame should throw if game does not exist', () async {
    final fakeFireStore = FakeFirebaseFirestore();
    final repo = FirestoreRepository(
      userEmail: 'test@test.com',
      firebaseFirestore: fakeFireStore,
    );
    await repo.createUserGame(123);

    expect(
        repo.deleteUserGame(555),
        throwsA(isA<Exception>().having(
          (p0) => p0.toString(),
          'message',
          'Exception: Game does not exist',
        )));
  });

  test('gameRef should be set when createUserGameCompletes ', () async {
    final fakeFireStore = FakeFirebaseFirestore();
    final repo = FirestoreRepository(
      userEmail: 'test@test.com',
      firebaseFirestore: fakeFireStore,
    );
    expect(repo.gameRef, isNull);

    expect(repo.createUserGame(123), completes);

    expect(repo.gameRef, isNot(isNull));
    expect(repo.gameRef!.id, '123');
  });

  test('Should fetch game from pin when fetchGameCalled', () async {
    final fakeFireStore = FakeFirebaseFirestore();
    final repo = FirestoreRepository(
      userEmail: 'test@test.com',
      firebaseFirestore: fakeFireStore,
    );

    repo.createUserGame(111);

    expect(await repo.fetchGame(111), const Game());
  });

  test('Should set gameRef when fetchGame called', () async {
    final fakeFireStore = FakeFirebaseFirestore();
    final repo = FirestoreRepository(
      userEmail: 'test@test.com',
      firebaseFirestore: fakeFireStore,
    );

    expect(repo.gameRef, isNull);

    repo.userGamesCollectionRef.doc('1234').set(const Game(p1Name: 'anything'));
    await repo.fetchGame(1234);

    expect(repo.gameRef, isNot(isNull));
    expect(await repo.fetchGame(1234), const Game(p1Name: 'anything'));
  });

  test('Should be able to update game after fetchGame called', () async {
    final fakeFireStore = FakeFirebaseFirestore();
    final repo = FirestoreRepository(
      userEmail: 'test@test.com',
      firebaseFirestore: fakeFireStore,
    );

    repo.userGamesCollectionRef.doc('1234').set(const Game());
    await repo.fetchGame(1234);

    expect(await repo.fetchGame(1234), const Game());
    await repo.updateName(playerPosition: 1, name: 'Bill');
    await repo.updateName(playerPosition: 2, name: 'Phil');
    await repo.updateScore(playerPosition: 1, score: 1);
    await repo.updateScore(playerPosition: 2, score: 2);

    expect(
      await repo.fetchGame(1234),
      const Game(
        p1Name: 'Bill',
        p2Name: 'Phil',
        p1Score: 1,
        p2Score: 2,
      ),
    );
  });

  test('Should properly update scores and names', () async {
    final fakeFireStore = FakeFirebaseFirestore();
    final repo = FirestoreRepository(
      userEmail: 'test@test.com',
      firebaseFirestore: fakeFireStore,
    );

    repo.createUserGame(111);

    expect(repo.updateName(playerPosition: 1, name: 'Nick'), completes);
    expect(repo.updateName(playerPosition: 2, name: 'Todd'), completes);
    expect(repo.updateScore(playerPosition: 1, score: 7), completes);
    expect(repo.updateScore(playerPosition: 2, score: 11), completes);

    expect(
        await repo.fetchGame(111),
        const Game(
          p1Name: 'Nick',
          p2Name: 'Todd',
          p1Score: 7,
          p2Score: 11,
        ));
  });

  test('Should throw if updating game before it is created', () async {
    final fakeFireStore = FakeFirebaseFirestore();
    final repo = FirestoreRepository(
      userEmail: 'test@test.com',
      firebaseFirestore: fakeFireStore,
    );
    Object? exception;

    runZonedGuarded(() {
      expect(repo.updateScore(playerPosition: 1, score: 123), throwsA(UnimplementedError()));
    }, (e, s) {
      exception = e;
    });

    expect(exception.toString(), 'Null check operator used on a null value');
  });
}
