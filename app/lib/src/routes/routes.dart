import 'package:authentication_public/authentication_public.dart';
import 'package:flutter/widgets.dart';
import 'package:smack_talking_scoreboard_v2/src/blocs/app/app_bloc.dart';
import 'package:smack_talking_scoreboard_v2/src/presentation/screens/home_screen.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomeScreen.page()];
    case AppStatus.unauthenticated:
    default:
      return [LoginPage.page()];
  }
}
