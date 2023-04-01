part of '../../stateful_bloc.dart';

@immutable
abstract class ExtendableState {
  const ExtendableState();

  List<Type> get superStates;
}

@immutable
abstract class _ExtendableStatefulBlocBase<State extends ExtendableState> {
  const _ExtendableStatefulBlocBase();

  @nonVirtual
  void emit(State state) {
    stateHolder._addState(state);
  }
}

class StatefulCubit<State extends ExtendableState>
    extends _ExtendableStatefulBlocBase<State> {
  const StatefulCubit();
}
