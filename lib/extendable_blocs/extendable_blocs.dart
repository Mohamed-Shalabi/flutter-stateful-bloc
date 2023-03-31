part of '../global_blocs.dart';

@immutable
abstract class _ExtendableStatefulBlocBase<State extends ExtendableState> {
  const _ExtendableStatefulBlocBase();

  void emit(State state);
}

class StatefulCubit<State extends ExtendableState> extends _ExtendableStatefulBlocBase<State> {
  const StatefulCubit();

  @override
  @nonVirtual
  void emit(State state) {
    _statesStreamController.add(state);
  }
}
