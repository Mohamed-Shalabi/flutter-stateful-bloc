import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'extendable_blocs/extendable_blocs.dart';
part 'stateful_bloc_widgets/stateful_bloc_consumer.dart';
part 'stateful_bloc_widgets/stateful_bloc_listener.dart';
part 'stateful_bloc_widgets/stateful_bloc_provider.dart';
part 'utils/bloc_state_holder.dart';
part 'utils/state_observer.dart';

@immutable
abstract class ExtendableState {
  const ExtendableState();

  Type get superState;
}

class _GlobalCubit extends Cubit<ExtendableState> {
  _GlobalCubit() : super(_GlobalInitialState()) {
    stateHolder._listen((state) {
      emit(state);
    });
  }

  @override
  // ignore: must_call_super
  void onChange(Change<ExtendableState> change) {
    final superStateType = change.nextState.superState;
    final currentState = change.nextState;
    var oldSimilarState = stateHolder.lastStateOfSuperType(superStateType);

    oldSimilarState ??= _GlobalInitialState();

    final callback = stateObserver._getStateObserver(superStateType);
    callback(oldSimilarState, currentState);
  }
}

class _GlobalInitialState extends ExtendableState {
  @override
  Type get superState => _GlobalInitialState;
}
