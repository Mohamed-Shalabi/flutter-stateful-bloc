import 'package:flutter/material.dart';
import 'package:flutter_stateful_bloc/flutter_stateful_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulProvider(
      stateMappers: [
        StateMapper<CounterIncrementState, ThatWordState>(
          function: (CounterIncrementState firstState) => ThatWordState(),
        ),
        StateMapper<CounterDecrementState, ThisWordState>(
          function: (CounterDecrementState firstState) => ThisWordState(),
        ),
      ],
      app: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: StateListener<CounterStates>(
        listener: (context, state) {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          if (state is CounterIncrementState) {
            scaffoldMessenger.hideCurrentSnackBar();
            scaffoldMessenger.showSnackBar(
              const SnackBar(content: Text('new value')),
            );
          }

          if (state is CounterDecrementState) {
            scaffoldMessenger.hideCurrentSnackBar();
            scaffoldMessenger.showSnackBar(
              const SnackBar(content: Text('new value')),
            );
          }
        },
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StateConsumer<WordStates>(
                initialState: ThisWordState(),
                builder: (context, state) => Text(
                  'You have pushed the button ${state.word} many times:',
                ),
              ),
              StateConsumer<CounterStates>(
                initialState: CounterInitialState(),
                builder: (context, state) {
                  return Text(
                    '${state.counter}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                },
              ),
              MixedStateConsumer<CounterStates, WordStates>(
                initialState1: CounterInitialState(),
                initialState2: ThisWordState(),
                builder: (
                  context,
                  lastState,
                  counterState,
                  wordState,
                ) {
                  return Text(
                    '${wordState.word}: ${counterState.counter}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

abstract class WordStates with ContextState {
  String get word;

  @override
  operator ==(Object? other) =>
      other.runtimeType == runtimeType &&
      other is WordStates &&
      word == other.word;

  @override
  int get hashCode => Object.hash(word, runtimeType);
}

class ThisWordState extends WordStates {
  @override
  String get word => 'this';
}

class ThatWordState extends WordStates {
  @override
  String get word => 'that';
}

abstract class CounterStates with ContextState {
  int get counter;

  @override
  operator ==(Object? other) =>
      other.runtimeType == runtimeType &&
      other is CounterStates &&
      counter == other.counter;

  @override
  int get hashCode => Object.hash(counter, runtimeType);
}

class CounterInitialState extends CounterStates {
  @override
  int get counter => 0;
}

class CounterIncrementState extends CounterStates {
  final int _counterValue;
  CounterIncrementState(this._counterValue);

  @override
  int get counter => _counterValue;
}

class CounterDecrementState extends CounterStates {
  final int _counterValue;

  CounterDecrementState(this._counterValue);

  @override
  int get counter => _counterValue;
}
