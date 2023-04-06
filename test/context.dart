import 'package:flutter/material.dart';
import 'package:flutter_stateful_bloc/flutter_stateful_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBlocProvider(
      stateMappers: {
        CounterIncrementState: [
          (state) {
            state = state as CounterIncrementState;
            return ThatWordState();
          },
        ],
        CounterDecrementState: [
          (state) {
            state = state as CounterDecrementState;
            return ThisWordState();
          },
        ],
      },
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
      body: StatefulBlocListener<CounterStates>(
        listener: (context, state) {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          if (state is CounterIncrementState) {
            scaffoldMessenger.hideCurrentSnackBar();
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text('new value: ${state.counter.toString()}')),
            );
          }

          if (state is CounterDecrementState) {
            scaffoldMessenger.hideCurrentSnackBar();
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text('new value: ${state.counter.toString()}')),
            );
          }
        },
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StatefulBlocConsumer<WordStates>(
                initialState: ThisWordState(),
                builder: (context, state) => Text(
                  'You have pushed the button ${state.word} many times:',
                ),
              ),
              StatefulBlocConsumer<CounterStates>(
                initialState: CounterInitialState(),
                builder: (context, state) {
                  return Text(
                    '${state.counter}',
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

abstract class WordStates implements SuperState {
  String get word;

  @override
  operator ==(Object? other) =>
      other is WordStates &&
      other.runtimeType == runtimeType &&
      word == other.word;

  @override
  int get hashCode => Object.hash(word, runtimeType);

  @override
  List<Type> get superStates => [WordStates];
}

class ThisWordState extends WordStates {
  @override
  String get word => 'this';
}

class ThatWordState extends WordStates {
  @override
  String get word => 'that';
}

abstract class CounterStates implements SuperState {
  int get counter;

  @override
  List<Type> get superStates => [CounterStates];

  @override
  operator ==(Object? other) =>
      other is CounterStates &&
      other.runtimeType == runtimeType &&
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
