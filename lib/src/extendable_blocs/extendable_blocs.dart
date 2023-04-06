part of '../../flutter_stateful_bloc.dart';

/// A class that is implemented by the states.
/// Override [parentStates] with the abstract class name and its parents.
@immutable
abstract class ContextState {
  const ContextState();

  List<Type> get parentStates;
}

extension SuperStateGetter on ContextState {
  @Deprecated('Changed getter name to parentStates')
  List<Type> get superStates => parentStates;
}

/// The base bloc that the user should extend.
@immutable
abstract class _StatelessBlocBase<State extends ContextState> {
  const _StatelessBlocBase();

  @nonVirtual
  void emit(State state) {
    stateHolder.addState(state);
  }
}

/// The first usable bloc that the user should extend.
class StatelessCubit<State extends ContextState>
    extends _StatelessBlocBase<State> {
  const StatelessCubit();
}
