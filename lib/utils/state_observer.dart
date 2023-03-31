part of '../global_blocs.dart';

StateObserverInterface get stateObserver => _StateObserver.instance;

typedef StateChanged = void Function(
  Type superState,
  ExtendableState previous,
  ExtendableState current,
);

abstract class StateObserverInterface {
  void setDefaultStateObserver(StateChanged stateChanged);

  void setStateObserver(Type type, StateChanged stateChanged);

  StateChanged _getStateObserver(Type type);
}

class _StateObserver implements StateObserverInterface {
  static _StateObserver instance = _StateObserver._();

  final Map<Type, StateChanged> _stateObservers = {};

  StateChanged _defaultStateObserver = (
    Type superState,
    ExtendableState previous,
    ExtendableState current,
  ) {
    if (kDebugMode) {
      print(
        'Scope $superState: '
        'Transitioning from ${previous.runtimeType} '
        'to ${current.runtimeType}',
      );
    }
  };

  _StateObserver._();

  @override
  void setDefaultStateObserver(StateChanged stateChanged) {
    _defaultStateObserver = stateChanged;
  }

  @override
  void setStateObserver(Type stateSuperType, StateChanged stateChanged) {
    _stateObservers[stateSuperType] = stateChanged;
  }

  @override
  StateChanged _getStateObserver(Type type) {
    return _stateObservers[type] ?? _defaultStateObserver;
  }
}
