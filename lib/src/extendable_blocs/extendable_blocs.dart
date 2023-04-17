part of '../../flutter_stateful_bloc.dart';

/// A class that is implemented by the abstract context states.
/// Override [parentStates] with the abstract class name and its parents.
@immutable
abstract class ContextState {}

/// The base bloc that should be extended.
/// See also:
/// - [StateHolderInterface].
@immutable
abstract class _StatelessBlocBase<State extends ContextState> {
  const _StatelessBlocBase();

  /// [emit] methid sends the [state] to the [StateHolderInterface.addState] method.
  @nonVirtual
  void emit(State state) {
    stateHolder.addState(state);
  }
}

/// The simplest usable bloc that the user should extend.
class StatelessCubit<State extends ContextState>
    extends _StatelessBlocBase<State> {
  const StatelessCubit();
}
