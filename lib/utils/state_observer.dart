part of '../global_blocs.dart';

final Map<Type, StateChanged> stateObservers = {};

StateChanged _defaultStateObserver = (
  ExtendableState previous,
  ExtendableState current,
) {
  if (kDebugMode) {
    print(
      'Scope ${current.superState}: '
      'Transitioning from ${previous.runtimeType} '
      'to ${current.runtimeType}',
    );
  }
};

void setDefaulstStateObserver(StateChanged stateChanged) {
  _defaultStateObserver = stateChanged;
}

void setStateObserver(Type stateSuperType, StateChanged stateChanged) {
  stateObservers[stateSuperType] = stateChanged;
}

typedef StateChanged = void Function(
  ExtendableState previous,
  ExtendableState current,
);
