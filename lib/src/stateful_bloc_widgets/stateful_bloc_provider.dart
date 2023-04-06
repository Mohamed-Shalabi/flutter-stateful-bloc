part of '../../flutter_stateful_bloc.dart';

/// A widget that adds the features of the package to the entire application.
class StatefulProvider extends StatelessWidget {
  const StatefulProvider({
    super.key,
    required this.app,
    this.stateMappers = const {},
  });

  final Widget app;
  final Map<Type, List<StateMapper>> stateMappers; 

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getGlobalCubitInstance(stateMappers),
      child: app,
    );
  }
}
