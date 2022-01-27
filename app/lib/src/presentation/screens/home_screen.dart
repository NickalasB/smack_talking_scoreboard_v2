import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scoreboard_public/src/scoreboard_bloc.dart';
import 'package:smack_talking_scoreboard_v2/src/blocs/app/app_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
    required this.firestore,
  }) : super(key: key);

  final FirebaseFirestore firestore;

  static Page page() => MaterialPage<void>(child: HomeScreen(firestore: FirebaseFirestore.instance));

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final user = context.select((AppBloc bloc) => bloc.state.user);

    return BlocProvider<ConcreteScoreboardBloc>(
      create: (context) => ConcreteScoreboardBloc(firestore),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(title: Text('Smack Talking Scoreboard'), actions: <Widget>[
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
              ],
            ),
          ),
        );
      }),
    );
  }
}
