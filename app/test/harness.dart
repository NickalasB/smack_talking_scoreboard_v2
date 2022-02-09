import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then/given_when_then.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> Function(WidgetTester) harness(WidgetTestHarnessCallback<_Harness> callback) {
  return (tester) => givenWhenThenWidgetTest(_Harness(tester), callback);
}

class _Harness extends WidgetTestHarness {
  _Harness(WidgetTester tester) : super(tester);
}

extension Given on WidgetTestGiven<_Harness> {}

extension When on WidgetTestWhen<_Harness> {
  Future<void> pumpMaterialWidget(Widget child) async {
    await tester.pumpWidgetBuilder(
      MaterialApp(
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: child,
        ),
      ),
    );
  }

  Future<void> userTaps(Finder finder) async {
    await tester.tap(finder);
  }

  Future<void> pump() async {
    await tester.pump();
  }

  Future<void> pumpAndSettle() async {
    await tester.pumpAndSettle();
  }
}

extension Then on WidgetTestThen<_Harness> {
  void findsOneWidget(Finder finder) {
    expect(finder, _findsOneWidget);
  }

  void findsNothing(Finder finder) {
    expect(finder, _findsNothing);
  }

  Future<void> screenMatchesGoldenFile(String goldenName) async {
    return screenMatchesGolden(this.harness.tester, goldenName);
  }
}

final _findsOneWidget = findsOneWidget;
final _findsNothing = findsNothing;
