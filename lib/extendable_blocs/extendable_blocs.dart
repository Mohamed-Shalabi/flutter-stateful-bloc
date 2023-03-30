part of '../global_blocs.dart';

@immutable
abstract class ExtendableStatefulBlocBase<State extends GlobalState> {
  const ExtendableStatefulBlocBase();

  void emit(State state);
}

class StatefulCubit<State extends GlobalState>
    extends ExtendableStatefulBlocBase<State> {
  const StatefulCubit();

  @override
  @nonVirtual
  void emit(State state) {
    _statesStreamController.add(state);
  }
}
