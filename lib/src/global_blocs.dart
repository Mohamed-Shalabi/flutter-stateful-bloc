part of '../stateful_bloc.dart';

/// The getter of the global instance of [_GlobalCubit].
_GlobalCubit _getGlobalCubitInstance(
  Map<Type, List<StateMapper>> stateMappers,
) {
  _globalCubit ??= _GlobalCubit(stateMappers);
  return _globalCubit!;
}

_GlobalCubit? _globalCubit;

/// The global cubit used in the entire application.
/// It is injected to the widget tree by [StatefulBlocProvider].
/// It must be injected over the whole app.
class _GlobalCubit extends Cubit<SuperState> {
  _GlobalCubit(this.stateMappers) : super(_GlobalInitialState()) {
    _subscription = stateHolder._listen((state) {
      emit(state);
      emitMappedStates(state);
    });
  }

  /// Emits all the states mapped from [state].
  void emitMappedStates(SuperState state) {
    final functions = stateMappers[state.runtimeType] ?? [];
    for (final function in functions) {
      final mappedState = function(state);
      emit(mappedState);
    }
  }

  /// Map of the type and its corresponding [StateMapper]s.
  final Map<Type, List<StateMapper>> stateMappers;
  /// Subscription of the states stream.
  /// All emitted states are passed through this stream Subscription.
  /// It is stored in a member variable to be able to cancel it in [close].
  late final StreamSubscription<SuperState> _subscription;

  /// Saves the lase emitted state from [change] to the [stateHolder].
  /// executes [stateObserver] functions.
  @override
  // ignore: must_call_super
  void onChange(Change<SuperState> change) {
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

/// The initial state of the application.
class _GlobalInitialState extends SuperState {
  @override
  List<Type> get superStates => [_GlobalInitialState];
}
