import 'package:async/async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then/given_when_then.dart';
import 'package:smack_talking_scoreboard_v2/blocs/auth/auth_bloc.dart';

void main() {}

class _Harness {
  late AuthBloc authBloc;
  late StreamQueue<AuthState> stateQueue;
}

Future<void> Function() harness(UnitTestHarnessCallback<_Harness> callback) {
  final harness = _Harness();
  // harness.fakeFirebaseFirestore = FakeFirebaseFirestore();

  harness.authBloc = ConcreteAuthBloc(harness.fakeFirebaseFirestore);

  harness.stateQueue = StreamQueue<AuthState>(harness.authBloc.stream);

  return () => givenWhenThenUnitTest(harness, callback);
}

extension on UnitTestWhen<_Harness> {
  Future<void> add(AuthEvent event) async {
    this.harness.authBloc.add(event);
    await tick();
  }

  Future<void> waitNextState() => this.harness.stateQueue.next;
}

extension on UnitTestThen<_Harness> {
  AuthState get state => this.harness.authBloc.state;

  void score(dynamic matcher) {
    expect(state.score, matcher);
  }
}

Future<void> tick() => Future.microtask(() {});
