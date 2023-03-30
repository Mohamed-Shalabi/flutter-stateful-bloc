import 'package:flutter/material.dart';

import 'global_blocs.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    cubit.increment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StatefulBlocListener(
        listener: (context, state) {
          if (state is CounterStates) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.counter.toString())),
            );
          }
        },
        body: StatefulBlocConsumer<CounterStates>(
          initialState: CounterInitialState(),
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '${state.counter}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

abstract class CounterStates extends GlobalState {
  final int counter;

  const CounterStates(this.counter);
}

class CounterInitialState extends CounterStates {
  const CounterInitialState() : super(0);
}

class CounterIncrementState extends CounterStates {
  const CounterIncrementState(super.counter);
}

class CounterDecrementState extends CounterStates {
  const CounterDecrementState(super.counter);
}

class CounterStatefulCubit extends StatefulCubit {
  const CounterStatefulCubit(this._repository);

  final CounterRepository _repository;

  void increment() {
    final newValue = _repository.increment();
    emit(CounterIncrementState(newValue));
  }
}

class CounterRepository {
  CounterRepository(this._dataSource);

  final CounterDataSource _dataSource;

  int get counter => _dataSource.counter;

  int increment() => _dataSource.increment();
}

class CounterDataSource {
  int counter = 0;

  int increment() => ++counter;
}
