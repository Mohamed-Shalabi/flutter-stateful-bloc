part of '../stateful_bloc.dart';

@immutable
abstract class ExtendableState {
  const ExtendableState();

  List<Type> get superStates;
}

_GlobalCubit get _globalCubitInstance {
  _globalCubit ??= _GlobalCubit();
  return _globalCubit!;
}

_GlobalCubit? _globalCubit;

class _GlobalCubit extends Cubit<ExtendableState> {
  _GlobalCubit() : super(_GlobalInitialState()) {
    _subscription = stateHolder._listen((state) {
      emit(state);
    });
  }

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
    _globalCubit = _GlobalCubit();
  }
}

class _GlobalInitialState extends ExtendableState {
  @override
  List<Type> get superStates => [_GlobalInitialState];
}
