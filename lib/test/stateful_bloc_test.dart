part of '../stateful_bloc.dart';

@isTest
// ignore: library_private_types_in_public_api
void statefulBlocTest<StatefulBloc extends StatefulCubit<State>,
    State extends SuperState>(
  String description, {
  required StatefulBloc Function() build,
  Map<Type, List<StateMapper>>? stateMappers,
  FutureOr<void> Function()? setUp,
  State Function()? seed,
  Function(StatefulBloc bloc)? act,
  Duration? wait,
  int skip = 0,
  dynamic Function()? expect,
  Function(StatefulBloc bloc)? verify,
  dynamic Function()? errors,
  FutureOr<void> Function()? tearDown,
  dynamic tags,
}) {
  late final StatefulBloc statefulBloc;
  blocTest<_GlobalCubit, SuperState>(
    description,
    setUp: setUp,
    build: () {
      statefulBloc = build();
      return _getGlobalCubitInstance(stateMappers ?? {});
    },
    seed: seed,
    act: (_) {
      if (act != null) {
        act(statefulBloc);
      }
    },
    wait: wait,
    skip: skip,
    expect: expect,
    verify: (_) {
      if (verify != null) {
        verify(statefulBloc);
      }
    },
    errors: errors,
    tearDown: tearDown,
    tags: tags,
  );
}
