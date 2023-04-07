part of '../../flutter_stateful_bloc.dart';

/// A widget that provide the [GlobalCubit] to the entire [app].
/// It should be used only once in the project above your [app].
class StatefulProvider extends StatelessWidget {
  const StatefulProvider({
    super.key,
    required this.app,
    this.stateMappers = const {},
  });

  final Widget app;

  /// [stateMappers] are a set of [StateMapper] for each state of type [Type] that are used to emit states of any type when a state of type [Type] is emitted.
  final Map<Type, List<StateMapper>> stateMappers;

  @override
  Widget build(BuildContext context) {
    if (context.read<GlobalCubit?>() != null) {
      throw 'You cannot use multiple StatefulProviders in your app';
    }

    return BlocProvider.value(
      value: getGlobalCubitInstance(stateMappers, true),
      child: app,
    );
  }
}
