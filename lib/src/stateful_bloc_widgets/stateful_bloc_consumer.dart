part of '../../stateful_bloc.dart';

class StatefulBlocConsumer<ConsumedState extends ExtendableState>
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
    return BlocBuilder<_GlobalCubit, ExtendableState>(
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

typedef StateWidgetBuilder<State extends ExtendableState> = Widget Function(
  BuildContext context,
  State state,
);
