import 'package:authentication_public/authentication_public.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smack_talking_scoreboard_v2/main.dart';
import 'package:smack_talking_scoreboard_v2/src/blocs/app/app_bloc.dart';
import 'package:smack_talking_scoreboard_v2/src/presentation/screens/home_screen.dart';

import '../test_helpers.dart';

class MockUser extends Mock implements ScoreboardUser {}

class MockAuthenticationRepository extends Mock implements Authentication {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  setUpFirebaseTests();

  group('App', () {
    late Authentication authenticationRepository;
    late ScoreboardUser user;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      user = MockUser();
      when(() => authenticationRepository.user).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => authenticationRepository.currentUser).thenReturn(user);
      when(() => user.isNotAnonymous).thenReturn(true);
      when(() => user.isAnonymous).thenReturn(false);
      when(() => user.email).thenReturn('test@gmail.com');
    });

    group('Goldens', () {
      testGoldens('HomeScreen', (tester) async {
        await tester.pumpWidgetBuilder(App(authentication: authenticationRepository));
        await screenMatchesGolden(tester, 'home_screen');
      });
    });

    testWidgets('renders AppView', (tester) async {
      await tester.pumpWidget(
        App(authentication: authenticationRepository),
      );
      await tester.pump();
      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late Authentication authenticationRepository;
    late AppBloc appBloc;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      appBloc = MockAppBloc();
    });

    testWidgets('navigates to LoginPage when unauthenticated', (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const AppView()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('navigates to HomePage when authenticated', (tester) async {
      final user = MockUser();
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const AppView()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
