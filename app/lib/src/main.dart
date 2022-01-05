import 'package:authentication_private/authentication_private.dart';
import 'package:authentication_public/authentication_public.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smack_talking_scoreboard_v2/firebase/firebase_options.dart';

import '../src/blocs/app/app_bloc.dart';
import '../src/presentation/screens/home_screen.dart';
import 'blocs/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  BlocOverrides.runZoned(
    () => runApp(App(authentication: authenticationRepository)),
    blocObserver: AppBlocObserver(),
  );
}

class App extends StatelessWidget {
  const App({
    Key? key,
    required Authentication authentication,
  })  : _authentication = authentication,
        super(key: key);

  final Authentication _authentication;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => _authentication,
      child: BlocProvider(
        create: (_) => AppBloc(authenticationRepository: _authentication),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: Builder(builder: (context) {
            return HomeScreen(
              title: 'Flutter Demo Home Page',
              authStatus: context.select((AppBloc bloc) => bloc.state.status),
              firestore: FirebaseFirestore.instance,
            );
          }),
        ),
      ),
    );
  }
}
