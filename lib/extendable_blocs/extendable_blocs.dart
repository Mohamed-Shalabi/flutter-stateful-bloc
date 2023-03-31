part of '../global_blocs.dart';

@immutable
abstract class _ExtendableStatefulBlocBase {
  const _ExtendableStatefulBlocBase();

  void emit(ExtendableState state);
}

class StatefulCubit extends _ExtendableStatefulBlocBase {
  const StatefulCubit();

  @override
  @nonVirtual
  void emit(ExtendableState state) {
    _statesStreamController.add(state);
  }
}
