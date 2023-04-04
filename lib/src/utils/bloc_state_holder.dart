part of '../../stateful_bloc.dart';

typedef StateAction = void Function(SuperState);

/// The global instance of [StateHolderInterface].
StateHolderInterface get stateHolder => _StateHolder.instance;

/// This is the interface used by the users to get the last state of a certain type.
/// It is used by the package to
/// - [_listen] to the states in the [_GlobalCubit].
/// - [_addState] in the [_ExtendableStatefulBlocBase.emit].
/// - [_saveStateAfterEmit] to save the last state of certain type.
abstract class StateHolderInterface {
  SuperState? lastStateOfSuperType(Type type);

  StreamSubscription<SuperState> _listen(StateAction action);

  void _addState<State extends SuperState>(State state);

  void _saveStateAfterEmit<State extends SuperState>(
      Type superStateType, State state);
}

class _StateHolder implements StateHolderInterface {
  static _StateHolder instance = _StateHolder._();
  final Map<Type, SuperState> _lastStates = {};
  final StreamController<SuperState> _statesStreamController =
      StreamController.broadcast();

  _StateHolder._();

  @override
  SuperState? lastStateOfSuperType(Type type) {
    return _lastStates[type];
  }

  @override
  StreamSubscription<SuperState> _listen(StateAction action) {
    return _statesStreamController.stream.listen(action);
  }

  @override
  void _addState<State extends SuperState>(State state) {
    _statesStreamController.add(state);
  }

  @override
  void _saveStateAfterEmit<State extends SuperState>(
    Type superStateType,
    State state,
  ) {
    _lastStates[superStateType] = state;
  }
}
