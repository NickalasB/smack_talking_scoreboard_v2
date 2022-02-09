import 'package:authentication_public/authentication_public.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart' as mock;
import 'package:smack_talking_scoreboard_v2/main.dart';
import 'package:smack_talking_scoreboard_v2/src/blocs/app/app_bloc.dart';
import 'package:smack_talking_scoreboard_v2/src/presentation/screens/home_screen.dart';

import '../harness.dart';
import '../test_helpers.dart';

class MockUser extends mock.Mock implements ScoreboardUser {}

class MockAuthenticationRepository extends mock.Mock implements Authentication {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  setUpFirebaseTests();

  group('App', () {
    late Authentication authenticationRepository;
    late ScoreboardUser user;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      user = MockUser();
      mock.when(() => authenticationRepository.user).thenAnswer(
            (_) => const Stream.empty(),
          );
      mock.when(() => authenticationRepository.currentUser).thenReturn(user);
      mock.when(() => user.isNotAnonymous).thenReturn(true);
      mock.when(() => user.isAnonymous).thenReturn(false);
      mock.when(() => user.email).thenReturn('test@gmail.com');
    });

    group('Goldens', () {
      testGoldens('HomeScreen', harness((given, when, then) async {
        await when.pumpMaterialWidget(App(authentication: authenticationRepository));
        await then.screenMatchesGoldenFile('home_screen');
      }));
    });

    testWidgets('renders AppView', harness((given, when, then) async {
      await when.pumpMaterialWidget(
        App(authentication: authenticationRepository),
      );
      await when.pump();
      expect(find.byType(AppView), findsOneWidget);
    }));
  });

  group('AppView', () {
    late Authentication authenticationRepository;
    late AppBloc appBloc;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      appBloc = MockAppBloc();
    });

    testWidgets('navigates to LoginPage when unauthenticated', harness((given, when, then) async {
      mock.when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
      await when.pumpMaterialWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const AppView()),
          ),
        ),
      );
      await when.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    }));

    testWidgets('navigates to HomePage when authenticated', harness((given, when, then) async {
      final user = MockUser();
      mock.when(() => user.email).thenReturn('test@gmail.com');
      mock.when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      await when.pumpMaterialWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const AppView()),
          ),
        ),
      );
      await when.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    }));
  });
}
