part of '../stateful_bloc.dart';

_GlobalCubit _getGlobalCubitInstance(
    Map<Type, List<StateMapper>> stateMappers) {
  _globalCubit ??= _GlobalCubit(stateMappers);
  return _globalCubit!;
}

_GlobalCubit? _globalCubit;

class _GlobalCubit extends Cubit<ExtendableState> {
  _GlobalCubit(this.stateMappers) : super(_GlobalInitialState()) {
    _subscription = stateHolder._listen((state) {
      emit(state);
      emitMappedStates(state);
    });
  }

  void emitMappedStates(ExtendableState state) {
    final functions = stateMappers[state.runtimeType] ?? [];
    for (final function in functions) {
      final mappedState = function(state);
      emit(mappedState);
    }
  }

  final Map<Type, List<StateMapper>> stateMappers;
  late final StreamSubscription<ExtendableState> _subscription;

  @override
  // ignore: must_call_super
  void onChange(Change<ExtendableState> change) {
    final superStatesTypes = change.nextState.superStates;
    final currentState = change.nextState;

    for (final superStateType in superStatesTypes) {
      var oldSimilarState = stateHolder.lastStateOfSuperType(superStateType);

      oldSimilarState ??= _GlobalInitialState();

      final callback = stateObserver._getStateObserver(superStateType);
      callback(superStateType, oldSimilarState, currentState);
      stateHolder._saveStateAfterEmit(superStateType, currentState);
    }
  }

  @override
  Future<void> close() async {
    _subscription.cancel();
    super.close();
    _globalCubit = _GlobalCubit(stateMappers);
  }
}

class _GlobalInitialState extends ExtendableState {
  @override
  List<Type> get superStates => [_GlobalInitialState];
}
