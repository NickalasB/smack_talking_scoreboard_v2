import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v2/main.dart';

import 'harness.dart';

void main() {
  testWidgets('Counter increments smoke test', harness((given, when, then) async {
    await given.pumpMaterialWidget(const MyApp());
    then.findOneWidget(find.text('0'));
    then.findNothing(find.text('1'));

    await when.userTaps(find.byIcon(Icons.add));
    await when.pump();
    then.findOneWidget(find.text('1'));
    then.findNothing(find.text('0'));
  }));
}
