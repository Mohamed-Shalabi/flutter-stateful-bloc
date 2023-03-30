part of '../global_bloc/global_cubit.dart';

class StatefulBlocProvider extends StatelessWidget {
  const StatefulBlocProvider({
    super.key,
    required this.app,
    required this.listener,
  });

  final Widget app;
  final BlocWidgetListener<GlobalState> listener;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _GlobalCubit(),
      child: BlocListener<_GlobalCubit, GlobalState>(
        listener: listener,
        child: app,
      ),
    );
  }
}
