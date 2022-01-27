import 'package:async/async.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then/given_when_then.dart';
import 'package:result_type/result_type.dart';
import 'package:scoreboard_private/firestore_private.dart';
import 'package:scoreboard_public/src/scoreboard_bloc.dart';

void main() {
  setUp(() {
    Firebase.delegatePackingProperty = FakeFirebase();
  });

  group('ScoreboardEvents', () {
    test('UpdateScoreEvent should have value-type equality', () {
      expect(const UpdateScoreEvent(1), equals(const UpdateScoreEvent(1)));
      expect(const UpdateScoreEvent(1), isNot(equals(const UpdateScoreEvent(2))));
    });
  });

  group('ScoreboardState', () {
    test('ScoreboardState should have value-type equality', () {
      expect(
        ScoreboardState(status: Status.loading, scoreResult: Success(1)),
        equals(ScoreboardState(status: Status.loading, scoreResult: Success(1))),
      );

      //result
      expect(
        ScoreboardState(scoreResult: Success(1)),
        isNot(equals(ScoreboardState(scoreResult: Success(2)))),
      );

      //status
      expect(
        const ScoreboardState(status: Status.loading),
        isNot(equals(const ScoreboardState(status: Status.loaded))),
      );
    });
  });

  group('ScoreboardBloc', () {
    test('Initial state should be of status: unknown and result null', harness((given, when, then) async {
      expect(
        given.harness.scoreboardBloc.state,
        equals(const ScoreboardState(status: Status.unknown, scoreResult: null)),
      );
      then.score(equals(0));
    }));

    test('Should emit new score when UpdateScoreEvent added', harness((given, when, then) async {
      await when.add(const UpdateScoreEvent(1));
      then.score(equals(1));

      await when.add(const UpdateScoreEvent(0));
      then.score(equals(0));
    }));
  });
}

class _Harness {
  late ScoreboardBloc scoreboardBloc;
  late StreamQueue<ScoreboardState> stateQueue;
  late FirestoreRepository firestoreRepo;
}

Future<void> Function() harness(UnitTestHarnessCallback<_Harness> callback) {
  final harness = _Harness();
  harness.firestoreRepo = FirestoreRepository(
    firebaseFirestore: FakeFirebaseFirestore(),
    userEmail: 'test@123.com',
  );

  harness.scoreboardBloc = ConcreteScoreboardBloc(harness.firestoreRepo);

  harness.stateQueue = StreamQueue<ScoreboardState>(harness.scoreboardBloc.stream);

  return () => givenWhenThenUnitTest(harness, callback);
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
