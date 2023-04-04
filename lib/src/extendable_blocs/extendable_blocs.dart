part of '../../stateful_bloc.dart';

/// A class that is implemented by the states.
/// Override [superStates] with the abstract class name and its parents.
@immutable
abstract class SuperState {
  const SuperState();

  List<Type> get superStates;
}

/// The base bloc that the user should extend.
@immutable
abstract class _ExtendableStatefulBlocBase<State extends SuperState> {
  const _ExtendableStatefulBlocBase();

  @nonVirtual
  void emit(State state) {
    stateHolder._addState(state);
  }
}

/// The first usable bloc that the user should extend.
class StatefulCubit<State extends SuperState>
    extends _ExtendableStatefulBlocBase<State> {
  const StatefulCubit();
}
