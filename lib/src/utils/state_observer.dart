part of '../../stateful_bloc.dart';

typedef StateChanged = void Function(
  Type superState,
  SuperState previous,
  SuperState current,
);

/// The global instance of [StateObserverInterface]
StateObserverInterface get stateObserver => _StateObserver.instance;

/// This interface is used to trace the states of the application.
abstract class StateObserverInterface {
  /// This method sets the default function that executes when a new state is emitted.
  void setDefaultStateObserver(StateChanged stateChanged);

  /// This method sets the  function that executes when a new state of type [Type] is emitted.
  void setStateObserver(Type type, StateChanged stateChanged);

  /// Gets the state observer of type [Type].
  StateChanged _getStateObserver(Type type);
}

class _StateObserver implements StateObserverInterface {
  static _StateObserver instance = _StateObserver._();

  final Map<Type, StateChanged> _stateObservers = {};

  StateChanged _defaultStateObserver = (
    Type superState,
    SuperState previous,
    SuperState current,
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
