import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v2/src/presentation/screens/home_screen.dart';

import 'harness.dart';
import 'test_helpers.dart';

void main() {
  setUpFirebaseTests();

  testWidgets('Counter increments smoke test', harness((given, when, then) async {
    final fakeFireStore = FakeFirebaseFirestore();
    await given.pumpMaterialWidget(
      HomeScreen(
        firestore: fakeFireStore,
      ),
    );
    then.findsOneWidget(find.text('0'));
    then.findsNothing(find.text('1'));

    await when.userTaps(find.byIcon(Icons.add));
    await when.pump();
    then.findsOneWidget(find.text('1'));
    then.findsNothing(find.text('0'));
  }));
}
