import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'stateful_bloc_widgets/stateful_bloc_provider.dart';
part 'stateful_bloc_widgets/stateful_bloc_consumer.dart';
part 'stateful_bloc_widgets/stateful_bloc_listener.dart';
part 'extendable_blocs/extendable_blocs.dart';
part 'utils/state_observer.dart';

final StreamController<ExtendableState> _statesStreamController =
    StreamController.broadcast();

class _GlobalCubit extends Cubit<ExtendableState> {
  _GlobalCubit() : super(_GlobalInitialState()) {
    _statesStreamController.stream.listen((state) {
      emit(state);
    });
  }

  final Map<Type, ExtendableState> lastStates = {};

  @override
  // ignore: must_call_super
  void onChange(Change<ExtendableState> change) {
    final superStateType = change.nextState.superState;
    final currentState = change.nextState;
    final oldSimilarState = lastStates[superStateType];

    if (oldSimilarState == null) {
      return;
    }

    final callback = stateObservers[superStateType];
    if (callback == null) {
      _defaultStateObserver(oldSimilarState, currentState);
    } else {
      callback(oldSimilarState, currentState);
    }

    lastStates[superStateType] = currentState;
  }
}

@immutable
abstract class ExtendableState {
  const ExtendableState();

  Type get superState;
}

class _GlobalInitialState extends ExtendableState {
  @override
  Type get superState => _GlobalInitialState;
}
