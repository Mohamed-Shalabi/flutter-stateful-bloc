part of '../global_bloc/global_cubit.dart';

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
