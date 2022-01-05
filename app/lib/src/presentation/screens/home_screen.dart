import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smack_talking_scoreboard_v2/src/blocs/app/app_bloc.dart';
import 'package:smack_talking_scoreboard_v2/src/blocs/scoreboard/scoreboard_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
    required this.title,
    required this.authStatus,
    required this.firestore,
  }) : super(key: key);

  final String title;
  final AppStatus authStatus;
  final FirebaseFirestore firestore;

  @override
  Widget build(BuildContext context) {
    int _counter = 0;

    return BlocProvider<ConcreteScoreboardBloc>(
      create: (context) => ConcreteScoreboardBloc(firestore),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '${context.watch<ConcreteScoreboardBloc>().state.score}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _counter++;
              context.read<ConcreteScoreboardBloc>().add(UpdateScoreEvent(_counter));
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        );
      }),
    );
  }
}
