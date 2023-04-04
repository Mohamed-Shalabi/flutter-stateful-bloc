import 'package:flutter/material.dart';

import 'stateful_bloc.dart';

final CounterStatefulCubit cubit = CounterStatefulCubit(
  CounterRepository(
    CounterDataSource(),
  ),
);

void main() {
  runApp(const MyApp());
}

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

  void _incrementCounter() {
    cubit.increment();
  }

  void _decrementCounter() {
    cubit.decrement();
  }

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
              SnackBar(content: Text(state.counter.toString())),
            );
          }

          if (state is CounterDecrementState) {
            scaffoldMessenger.hideCurrentSnackBar();
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text(state.counter.toString())),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            heroTag: 'increment',
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            heroTag: 'decrement',
            onPressed: _decrementCounter,
            tooltip: 'decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

abstract class WordStates implements ExtendableState {
  String get word;

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

abstract class CounterStates implements ExtendableState {
  int get counter;

  @override
  List<Type> get superStates => [CounterStates];
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

class CounterStatefulCubit extends StatefulCubit<CounterStates> {
  const CounterStatefulCubit(this._repository);

  final CounterRepository _repository;

  void increment() {
    final newValue = _repository.increment();
    emit(CounterIncrementState(newValue));
  }

  void decrement() {
    final newValue = _repository.decrement();
    emit(CounterDecrementState(newValue));
  }
}

class CounterRepository {
  CounterRepository(this._dataSource);

  final CounterDataSource _dataSource;

  int get counter => _dataSource.counter;

  int increment() => _dataSource.increment();

  int decrement() => _dataSource.decrement();
}

class CounterDataSource {
  int counter = 0;

  int increment() => ++counter;

  int decrement() => --counter;
}
