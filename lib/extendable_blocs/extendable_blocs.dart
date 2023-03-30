part of '../global_blocs.dart';

@immutable
abstract class ExtendableStatefulBlocBase<State extends ExtendableState> {
  const ExtendableStatefulBlocBase();

  void emit(State state);
}

class StatefulCubit<State extends ExtendableState>
    extends ExtendableStatefulBlocBase<State> {
  const StatefulCubit();

  @override
  @nonVirtual
  void emit(State state) {
    _statesStreamController.add(state);
  }
}
