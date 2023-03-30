part of '../global_blocs.dart';

abstract class ExtendableStatefulBlocBase<State extends GlobalState> {
  void emit(State state);
}

class StatefulCubit<State extends GlobalState>
    extends ExtendableStatefulBlocBase<State> {
  @override
  @nonVirtual
  void emit(State state) {
    _statesStreamController.add(state);
  }
}
