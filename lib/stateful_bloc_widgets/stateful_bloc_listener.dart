part of '../global_blocs.dart';

class StatefulBlocListener extends StatelessWidget {
  const StatefulBlocListener({
    super.key,
    required this.listener,
    required this.body,
  });

  final BlocWidgetListener<ExtendableState> listener;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return BlocListener<_GlobalCubit, ExtendableState>(
      listener: listener,
      child: body,
    );
  }
}
