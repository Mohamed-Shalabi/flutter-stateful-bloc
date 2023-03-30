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

class StatefulBlocListener extends StatelessWidget {
  const StatefulBlocListener({
    super.key,
    required this.listener,
    required this.body,
  });

  final BlocWidgetListener<GlobalState> listener;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return BlocListener<_GlobalCubit, GlobalState>(
      listener: listener,
      child: body,
    );
  }
}
