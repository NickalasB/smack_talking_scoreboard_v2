import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:scoreboard_private/firestore_private.dart';
import 'package:scoreboard_public/scoreboard_public.dart';
import 'package:smack_talking_scoreboard_v2/src/blocs/app/app_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomeScreen());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final user = context.select((AppBloc bloc) => bloc.state.user);

    return BlocProvider<ScoreboardBloc>(
      create: (context) => ConcreteScoreboardBloc(
        FirestoreRepository(
          firebaseFirestore: FirebaseFirestore.instance,
          userEmail: user.email ?? '',
        ),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Smack Talking Scoreboard'), actions: <Widget>[
          IconButton(
            key: const Key('homePage_logout_iconButton'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
          )
        ]),
        body: Align(
          alignment: const Alignment(0, -1 / 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 4),
              Text(user.email ?? '', style: textTheme.headline6),
              const SizedBox(height: 4),
              Text(user.name ?? '', style: textTheme.headline5),
              const SizedBox(height: 4),
              Builder(builder: (context) {
                return Builder(builder: (context) {
                  return TextButton(
                      child: const Text('CreateGame'),
                      onPressed: () {
                        context.read<ScoreboardBloc>().add(const CreateUserGameEvent(666));
                      });
                });
              }),
              Builder(builder: (context) {
                return Builder(builder: (context) {
                  return TextButton(
                      child: const Text('Delete Game'),
                      onPressed: () {
                        context.read<ScoreboardBloc>().add(const DeleteGameEvent(pin: 666));
                      });
                });
              })
            ],
          ),
        ),
      ),
    );
  }
}
