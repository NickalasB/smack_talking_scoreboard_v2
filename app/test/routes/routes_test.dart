import 'package:authentication_public/authentication_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smack_talking_scoreboard_v2/src/blocs/app/app_bloc.dart';
import 'package:smack_talking_scoreboard_v2/src/presentation/screens/home_screen.dart';
import 'package:smack_talking_scoreboard_v2/src/routes/routes.dart';

import '../test_helpers.dart';

void main() {
  setUpFirebaseTests();

  group('onGenerateAppViewPages', () {
    test('returns [HomePage] when authenticated', () {
      expect(
        onGenerateAppViewPages(AppStatus.authenticated, []),
        [isA<MaterialPage>().having((p) => p.child, 'child', isA<HomeScreen>())],
      );
    });

    test('returns [LoginPage] when unauthenticated', () {
      expect(
        onGenerateAppViewPages(AppStatus.unauthenticated, []),
        [isA<MaterialPage>().having((p) => p.child, 'child', isA<LoginPage>())],
      );
    });
  });
}
