// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:authentication_private/authentication_private.dart';
import 'package:authentication_public/authentication_public.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smack_talking_scoreboard_v2/src/blocs/app/app_bloc.dart';

import '../test_helpers.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

class MockUser extends Mock implements ScoreboardUser {}

void main() {
  setUpFirebaseTests();

  group('AppBloc', () {
    final user = MockUser();
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(() => authenticationRepository.user).thenAnswer(
        (_) => Stream.empty(),
      );
      when(
        () => authenticationRepository.currentUser,
      ).thenReturn(ScoreboardUser.anonymous);
      when(
        () => authenticationRepository.logOut(),
      ).thenAnswer((_) async {});
    });

    test('initial state is unauthenticated when user is anonymous', () {
      expect(
        AppBloc(authenticationRepository: authenticationRepository).state,
        AppState.unauthenticated(),
      );
    });

    group('UserChanged', () {
      blocTest<AppBloc, AppState>(
        'emits authenticated when user is not anonymous',
        build: () {
          when(() => user.isNotAnonymous).thenReturn(true);
          when(() => authenticationRepository.user).thenAnswer(
            (_) => Stream.value(user),
          );
          return AppBloc(authenticationRepository: authenticationRepository);
        },
        seed: () => AppState.unauthenticated(),
        expect: () => [AppState.authenticated(user)],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when user is anonymous',
        build: () {
          when(() => authenticationRepository.user).thenAnswer(
            (_) => Stream.value(ScoreboardUser.anonymous),
          );
          return AppBloc(authenticationRepository: authenticationRepository);
        },
        expect: () => [AppState.unauthenticated()],
      );
    });

    group('LogoutRequested', () {
      blocTest<AppBloc, AppState>(
        'invokes logOut',
        build: () {
          return AppBloc(authenticationRepository: authenticationRepository);
        },
        act: (bloc) => bloc.add(AppLogoutRequested()),
        verify: (_) {
          verify(() => authenticationRepository.logOut()).called(1);
        },
      );
    });
  });
}
