part of '../../stateful_bloc.dart';

StateHolderInterface get stateHolder => _StateHolder.instance;

typedef StateAction = void Function(ExtendableState);

abstract class StateHolderInterface {
  ExtendableState? lastStateOfSuperType(Type type);

  StreamSubscription<ExtendableState> _listen(StateAction action);

  void _addState<State extends ExtendableState>(State state);

  void _saveStateAfterEmit<State extends ExtendableState>(
      Type superStateType, State state);
}

class _StateHolder implements StateHolderInterface {
  static _StateHolder instance = _StateHolder._();
  final Map<Type, ExtendableState> _lastStates = {};
  final StreamController<ExtendableState> _statesStreamController =
      StreamController.broadcast();

  _StateHolder._();

  @override
  ExtendableState? lastStateOfSuperType(Type type) {
    return _lastStates[type];
  }

  @override
  StreamSubscription<ExtendableState> _listen(StateAction action) {
    return _statesStreamController.stream.listen(action);
  }

  @override
  void _addState<State extends ExtendableState>(State state) {
    _statesStreamController.add(state);
  }

  @override
  void _saveStateAfterEmit<State extends ExtendableState>(
    Type superStateType,
    State state,
  ) {
    _lastStates[superStateType] = state;
  }
}
