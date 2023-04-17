part of '../../flutter_stateful_bloc.dart';

final StateObserver stateObserver = _StateObserverImpl();

typedef StateChanged<State extends ContextState> = void Function(
  State? previous,
  State current,
);

abstract class StateObserver {
  void observe<State extends ContextState>([StateChanged<State>? stateChanged]);

  void setDefaultStateObserver(StateChanged<ContextState> stateChanged);

}

class _StateObserverImpl implements StateObserver {
  var subscriptions = <Type, StreamSubscription<ContextState>>{};
  void Function(
    Type type,
    ContextState previous,
    ContextState current,
  ) _defaultStateObserver = (type, previous, current) {
    if (kDebugMode) {
      print(
        'Scope $State: '
        'Transitioning from ${previous.runtimeType} '
        'to ${current.runtimeType}',
      );
    }
  };

  @override
  void observe<State extends ContextState>([
    StateChanged<State>? stateChanged,
  ]) {
    if (State == dynamic) {
      throw 'You must provide the generic type';
    }

    stateChanged ??= _getDefaultStateObserver<State>();

    State? lastState;
    final subscription = stateHolder._listen(
      (state) {
        if (state is State) {
          stateChanged?.call(lastState, state);
          lastState = state;
        }
      },
    );

    subscriptions[State]?.cancel();
    subscriptions[State] = subscription;
  }

  @override
  void setDefaultStateObserver(StateChanged<ContextState> stateChanged) {
    _defaultStateObserver = (type, previous, current) {
      return stateChanged(previous, current);
    };
  }

  StateChanged<State> _getDefaultStateObserver<State extends ContextState>() =>
      (
        State? previous,
        State current,
      ) {
        return _defaultStateObserver(
          State,
          previous ?? _GlobalInitialState(),
          current,
        );
      };
}
