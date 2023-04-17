part of '../flutter_stateful_bloc.dart';

/// The getter of the global instance of [GlobalCubit].
@visibleForTesting
GlobalCubit getGlobalCubitInstance(
  Map<Type, List<StateMapper>> stateMappers, [
  bool isNewInstance = false,
]) {
  if (isNewInstance || _globalCubit == null) {
    _globalCubit?.cancelStream();
    _globalCubit = GlobalCubit(
      stateMappers,
      stateHolder,
    );
  }

  return _globalCubit!;
}

GlobalCubit? _globalCubit;

/// The global cubit used in the entire application.
/// It is injected to the widget tree by [StatefulProvider].
/// It must be injected over the whole app.
@visibleForTesting
class GlobalCubit extends Cubit<ContextState> {
  GlobalCubit(this.stateMappers, this._stateHolder)
      : super(_GlobalInitialState()) {
    _subscription = _stateHolder._listen((state) {
      emit(state);
      if (state is _GlobalInitialState) {
        return;
      }

      _emitMappedStates(state);
    });
  }

  /// Emits all the states mapped from [state].
  void _emitMappedStates(ContextState state) {
    final functions = [
      ...(stateMappers[state.runtimeType] ?? []),
    ];

    for (final function in functions) {
      final mappedState = function(state);
      emit(mappedState);
    }
  }

  /// Map of the type and its corresponding [StateMapper]s.
  final Map<Type, List<StateMapper>> stateMappers;
  final StateHolderInterface _stateHolder;
  late final StreamSubscription<ContextState> _subscription;

  /// Saves the lase emitted state from [change] to the [_stateHolder].
  /// executes [_stateObserver] functions.
  @override
  // ignore: must_call_super
  void onChange(Change<ContextState> change) {}

  /// Overriding [super.close] to never dispose the cubit.
  @override
  // ignore: must_call_super
  Future<void> close() async {}

  @visibleForTesting
  void cancelStream() {
    _subscription.cancel();
    super.close();
  }
}

/// The initial state of the application.
class _GlobalInitialState extends ContextState {}
