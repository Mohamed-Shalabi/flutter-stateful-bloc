import 'package:flutter_stateful_bloc/flutter_stateful_bloc.dart';

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
