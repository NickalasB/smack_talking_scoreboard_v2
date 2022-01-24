import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_private/src/firestore_repository.dart';
import 'package:firestore_public/firestore_public.dart';
import 'package:flutter_test/flutter_test.dart';

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

  test('Should properly update scores and names', () async {
    final fakeFireStore = FakeFirebaseFirestore();
    final repo = FirestoreRepository(
      userEmail: 'test@test.com',
      firebaseFirestore: fakeFireStore,
    );

    repo.createUserGame(111);

    expect(repo.updateP1Name('Nick'), completes);
    expect(repo.updateP2Name('Todd'), completes);
    expect(repo.updateP1Score(7), completes);
    expect(repo.updateP2Score(11), completes);

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
      expect(repo.updateP1Score(123), throwsA(UnimplementedError()));
    }, (e, s) {
      exception = e;
    });

    expect(exception.toString(), 'Null check operator used on a null value');
  });
}
