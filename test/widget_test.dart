import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v2/main.dart';

import 'harness.dart';

void main() {
  testWidgets('Counter increments smoke test', harness((given, when, then) async {
    await given.pumpMaterialWidget(const MyApp());
    then.findsOneWidget(find.text('0'));
    then.findsNothing(find.text('1'));

    await when.userTaps(find.byIcon(Icons.add));
    await when.pump();
    then.findsOneWidget(find.text('1'));
    then.findsNothing(find.text('0'));
  }));
}
