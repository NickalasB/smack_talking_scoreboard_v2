import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smack_talking_scoreboard_v2/blocs/scoreboard/scoreboard_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    int _counter = 0;

    return BlocProvider<ScoreboardBloc>(
      create: (context) => ScoreboardBloc(),
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
                  '${context.watch<ScoreboardBloc>().state.score}',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _counter++;
              context.read<ScoreboardBloc>().add(UpdateScoreEvent(_counter));
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        );
      }),
    );
  }
}
