part of '../../stateful_bloc.dart';

/// A widget that rebuilds its child when a new state of type [ConsumedState] is emitted.
class StatefulBlocConsumer<ConsumedState extends SuperState>
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
    return BlocBuilder<_GlobalCubit, SuperState>(
      buildWhen: (previous, current) {
        return current is ConsumedState && current != previous ||
            current is _GlobalInitialState;
      },
      builder: (BuildContext context, state) {
        if (state is _GlobalInitialState) {
          state = initialState;
          stateHolder._addState(state);
        }

        return builder(
          context,
          state as ConsumedState,
        );
      },
    );
  }
}

typedef StateWidgetBuilder<State extends SuperState> = Widget Function(
  BuildContext context,
  State state,
);
