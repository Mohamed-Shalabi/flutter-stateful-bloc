part of '../flutter_stateful_bloc.dart';

/// The getter of the global instance of [GlobalCubit].
@visibleForTesting
GlobalCubit getGlobalCubitInstance(
  Map<Type, List<StateMapper>> stateMappers,
) {
  _globalCubit ??= GlobalCubit(
    stateMappers,
    stateHolder,
    stateObserver,
  );
  return _globalCubit!;
}

GlobalCubit? _globalCubit;

/// The global cubit used in the entire application.
/// It is injected to the widget tree by [StatefulBlocProvider].
/// It must be injected over the whole app.
@visibleForTesting
class GlobalCubit extends Cubit<SuperState> {
  GlobalCubit(this.stateMappers, this._stateHolder, this._stateObserver)
      : super(_GlobalInitialState()) {
    _stateHolder._listen((state) {
      emit(state);
      _emitMappedStates(state);
    });
  }

  /// Emits all the states mapped from [state].
  void _emitMappedStates(SuperState state) {
    final functions = stateMappers[state.runtimeType] ?? [];
    for (final function in functions) {
      final mappedState = function(state);
      emit(mappedState);
    }
  }

  /// Map of the type and its corresponding [StateMapper]s.
  final Map<Type, List<StateMapper>> stateMappers;
  final StateHolderInterface _stateHolder;
  final StateObserverInterface _stateObserver;

  /// Saves the lase emitted state from [change] to the [_stateHolder].
  /// executes [_stateObserver] functions.
  @override
  // ignore: must_call_super
  void onChange(Change<SuperState> change) {
    final superStatesTypes = change.nextState.superStates;
    final currentState = change.nextState;

    for (final superStateType in superStatesTypes) {
      var oldSimilarState = _stateHolder.lastStateOfSuperType(superStateType);

      oldSimilarState ??= _GlobalInitialState();

      final callback = _stateObserver._getStateObserver(superStateType);
      callback(superStateType, oldSimilarState, currentState);
      _stateHolder.saveStateAfterEmit(superStateType, currentState);
    }
  }

  @override
  // ignore: must_call_super
  Future<void> close() async {}

  @visibleForTesting
  void cancelStream() {
    super.close();
  }
}

/// The initial state of the application.
class _GlobalInitialState extends SuperState {
  @override
  List<Type> get superStates => [_GlobalInitialState];
}
