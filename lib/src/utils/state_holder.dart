part of '../../flutter_stateful_bloc.dart';

typedef StateAction = void Function(ContextState);

/// The global instance of [StateHolderInterface].
StateHolderInterface get stateHolder => _StateHolder.instance;

// TODO: split this api into two separate interfaces

/// This is the interface used by the users to get the last state of a certain type.
/// It is used by the package to
/// - [_listen] to the states in the [GlobalCubit].
/// - [_addState] in the [_StatelessBlocBase.emit].
/// - [saveStateAfterEmit] to save the last state of certain type.
abstract class StateHolderInterface {
  /// The only public method in this interface.
  /// It is used to get the last state with context type [Type].
  /// Don't use it outside [Widget] build method and [ContextState]s constructors.
  ContextState? lastStateOfContextType(Type type);

  StreamSubscription<ContextState> _listen(StateAction action);

  @visibleForTesting
  void addState<State extends ContextState>(State state);

  @visibleForTesting
  void saveStateAfterEmit<State extends ContextState>(
    Type superStateType,
    State state,
  );

  @visibleForTesting
  void clear();
}

/// The implementation of [StateHolderInterface].
class _StateHolder implements StateHolderInterface {
  static _StateHolder instance = _StateHolder._();
  final Map<Type, ContextState> _lastStates = {};
  final StreamController<ContextState> _statesStreamController =
      StreamController.broadcast();

  _StateHolder._();

  @override
  ContextState? lastStateOfContextType(Type type) {
    return _lastStates[type];
  }

  @override
  StreamSubscription<ContextState> _listen(StateAction action) {
    return _statesStreamController.stream.listen(action);
  }

  @override
  void addState<State extends ContextState>(State state) {
    _statesStreamController.add(state);
  }

  @override
  void saveStateAfterEmit<State extends ContextState>(
    Type superStateType,
    State state,
  ) {
    _lastStates[superStateType] = state;
  }

  @override
  void clear() {
    _lastStates.clear();
    addState(_GlobalInitialState());
  }
}
