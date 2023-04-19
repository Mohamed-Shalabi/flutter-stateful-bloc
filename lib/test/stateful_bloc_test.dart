part of '../flutter_stateful_bloc.dart';

@isTest
// ignore: library_private_types_in_public_api
void statefulBlocTest<StatefulBloc extends StatelessCubit<State>,
    State extends ContextState>(
  String description, {
  required StatefulBloc Function() build,
  List<StateMapper>? stateMappers,
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
  blocTest<GlobalCubit, ContextState>(
    description,
    setUp: setUp,
    build: () {
      statefulBloc = build();
      return getGlobalCubitInstance(stateMappers ?? []);
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
