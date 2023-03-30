part of '../global_blocs.dart';

class StatefulBlocConsumer<ConsumedState extends GlobalState>
    extends StatelessWidget {
  const StatefulBlocConsumer({
    super.key,
    required this.builder,
    required this.initialState,
  });

  final StateWidgetBuilder<ConsumedState> builder;
  final ConsumedState initialState;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<_GlobalCubit, GlobalState>(
      buildWhen: (previous, current) {
        return current is ConsumedState && current != previous;
      },
      builder: (BuildContext context, state) {
        return builder(
          context,
          state is _GlobalInitialState ? initialState : state as ConsumedState,
        );
      },
    );
  }
}

typedef StateWidgetBuilder<State extends GlobalState> = Widget Function(
  BuildContext context,
  State state,
);
