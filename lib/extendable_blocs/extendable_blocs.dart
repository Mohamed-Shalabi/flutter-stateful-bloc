part of '../global_blocs.dart';

@immutable
abstract class ExtendableStatefulBlocBase {
  const ExtendableStatefulBlocBase();

  void emit(ExtendableState state);
}

class StatefulCubit extends ExtendableStatefulBlocBase {
  const StatefulCubit();

  @override
  @nonVirtual
  void emit(ExtendableState state) {
    _statesStreamController.add(state);
  }
}
