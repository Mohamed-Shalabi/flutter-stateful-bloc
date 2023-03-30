import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

part 'stateful_bloc_widgets/stateful_bloc_provider.dart';
part 'stateful_bloc_widgets/stateful_bloc_consumer.dart';
part 'extendable_blocs/extendable_blocs.dart';

final StreamController<GlobalState> _statesStreamController =
    StreamController.broadcast();

class _GlobalCubit extends Cubit<GlobalState> {
  _GlobalCubit() : super(_GlobalInitialState()) {
    _statesStreamController.stream.listen((state) {
      emit(state);
    });
  }
}

@immutable
abstract class GlobalState {
  const GlobalState();
}

class _GlobalInitialState extends GlobalState {}
