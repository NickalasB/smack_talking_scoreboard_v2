import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then/given_when_then.dart';
import 'package:mocktail/mocktail.dart' as mock;
import 'package:result_type/result_type.dart';
import 'package:scoreboard_private/firestore_private.dart';
import 'package:scoreboard_public/scoreboard_public.dart';
import 'package:scoreboard_public/src/scoreboard_bloc.dart';

class MockFirebaseRepo extends mock.Mock implements FirestoreRepository {}

void main() {
  setUp(() {
    Firebase.delegatePackingProperty = FakeFirebase();
  });

  group('ScoreboardBloc', () {
    test('Initial state should be of status: unknown and result null', harness((given, when, then) async {
      given.scoreboardBlocSetUp();
      expect(
        given.harness.scoreboardBloc.state,
        equals(const ScoreboardState(status: Status.unknown, scoreResult: null)),
      );
      then.score(equals(0));
    }));

    group('CreateUserGame', () {
      test('Should emit proper state when CreateUserGameEvent added successfully', harness((given, when, then) async {
        given.scoreboardBlocSetUp();
        await when.add(const CreateUserGameEvent(321));
        expect(then.state, const ScoreboardState(status: Status.loaded));
      }));

      test('Should emit unknown state when CreateUserGameEvent fails', harness((given, when, then) async {
        given.scoreboardBlocSetUp(withMockRepo: true);

        mock.when(() => when.harness.firestoreRepo.createUserGame(123)).thenThrow(() => Exception());

        await when.add(const CreateUserGameEvent(321));
        expect(then.state, const ScoreboardState(status: Status.unknown));
      }));
    });

    group('UpdateP1ScoreEvent', () {
      test('Should emit new score when UpdateP1ScoreEvent successfully added', harness((given, when, then) async {
        given.scoreboardBlocSetUp();
        await given.gameCreated();
        await when.add(const UpdateP1ScoreEvent(1));
        then.score(equals(1));

        await when.add(const UpdateP1ScoreEvent(0));
        then.score(equals(0));
      }));

      test('Should emit failure score when UpdateScoreEvent fails', harness((given, when, then) async {
        given.scoreboardBlocSetUp(withMockRepo: true);
        mock.when(() => when.harness.firestoreRepo.createUserGame(123)).thenAnswer((invocation) async {});
        mock
            .when(() => when.harness.firestoreRepo.updateScore(playerPosition: 1, score: 1))
            .thenThrow(() => Exception());

        await when.add(const UpdateP1ScoreEvent(1));
        expect(then.state, ScoreboardState(status: Status.unknown, scoreResult: Failure('Failed to update p1Score')));
      }));
    });
  });
}

class _Harness {
  late ScoreboardBloc scoreboardBloc;
  late StreamQueue<ScoreboardState> stateQueue;
  late final FirebaseFirestore fakeFirebaseFirestore = FakeFirebaseFirestore();
  late FirestoreRepository firestoreRepo;
}

Future<void> Function() harness(UnitTestHarnessCallback<_Harness> callback) {
  final harness = _Harness();
  return () => givenWhenThenUnitTest(harness, callback);
}

extension on UnitTestGiven<_Harness> {
  void scoreboardBlocSetUp({bool withMockRepo = false}) {
    this.harness.firestoreRepo = withMockRepo
        ? MockFirebaseRepo()
        : FirestoreRepository(
            firebaseFirestore: FakeFirebaseFirestore(),
            userEmail: 'test@123.com',
          );
    this.harness.scoreboardBloc = ConcreteScoreboardBloc(this.harness.firestoreRepo);
    this.harness.stateQueue = StreamQueue<ScoreboardState>(this.harness.scoreboardBloc.stream);
  }

  Future<void> gameCreated({int pin = 123}) async {
    return this.harness.firestoreRepo.createUserGame(pin);
  }
}

extension on UnitTestWhen<_Harness> {
  Future<void> add(ScoreboardEvent event) async {
    this.harness.scoreboardBloc.add(event);
    await tick();
  }

  Future<void> waitNextState() => this.harness.stateQueue.next;
}

extension on UnitTestThen<_Harness> {
  ScoreboardState get state => this.harness.scoreboardBloc.state;

  void score(dynamic matcher) {
    expect(state.score, matcher);
  }
}

Future<void> tick() => Future.microtask(() {});

class FakeFirebase extends FirebasePlatform {
  FakeFirebase();
  @override
  FirebaseAppPlatform app([String name = defaultFirebaseAppName]) {
    return FirebaseAppPlatform(
      'test',
      const FirebaseOptions(
        appId: 'test',
        projectId: '1234',
        apiKey: '321',
        messagingSenderId: 'anything',
      ),
    );
  }
}
