part of '../../flutter_stateful_bloc.dart';

/// The global instance of [StateHolderInterface].
StateHolderInterface get stateHolder => _StateHolder.instance;

typedef StateAction = void Function(ContextState);

// TODO: split this api into two separate interfaces

/// This is the interface used by the users to get the last state of a certain type.
/// It is used by the package to
/// - [_listen] to the states in the [GlobalCubit].
/// - [_addState] in the [_StatelessBlocBase.emit].
/// - [saveStateAfterEmit] to save the last state of certain type.
abstract class StateHolderInterface {
  @visibleForTesting
  void addState<State extends ContextState>(State state);

  @visibleForTesting
  void clear();

  /// The only public method in this interface.
  /// It is used to get the last state with context type [Type].
  /// Don't use it outside [Widget] build method and [ContextState]s constructors.
  State? lastStateOfContextType<State extends ContextState>();

  StreamSubscription<ContextState> _listen(StateAction action);
}

/// The implementation of [StateHolderInterface].
class _StateHolder implements StateHolderInterface {
  static _StateHolder instance = _StateHolder._();
  final _lastStates = <ContextState>[];
  final StreamController<ContextState> _statesStreamController =
      StreamController.broadcast();

  _StateHolder._();

  @override
  void addState<State extends ContextState>(State state) {
    _statesStreamController.add(state);
    _lastStates.add(state);
  }

  @override
  void clear() {
    _lastStates.clear();
    addState(_GlobalInitialState());
  }

  @override
  State? lastStateOfContextType<State extends ContextState>() {
    if (State == dynamic) {
      throw 'You must add the generic type.';
    }

    State? result;

    for (final state in _lastStates) {
      if (state is State) {
        result = state;
      }
    }

    return result;
  }

  @override
  StreamSubscription<ContextState> _listen(StateAction action) {
    return _statesStreamController.stream.listen(action);
  }
}
