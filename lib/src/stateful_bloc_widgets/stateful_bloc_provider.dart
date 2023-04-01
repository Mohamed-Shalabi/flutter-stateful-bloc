part of '../global_blocs.dart';

class StatefulBlocProvider extends StatelessWidget {
  const StatefulBlocProvider({
    super.key,
    required this.app,
  });

  final Widget app;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _GlobalCubit(),
      child: app,
    );
  }
}
