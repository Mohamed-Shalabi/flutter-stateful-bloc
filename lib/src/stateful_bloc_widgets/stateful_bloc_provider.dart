part of '../../stateful_bloc.dart';

class StatefulBlocProvider extends StatelessWidget {
  const StatefulBlocProvider({
    super.key,
    required this.app,
  });

  final Widget app;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _globalCubitInstance,
      child: app,
    );
  }
}
