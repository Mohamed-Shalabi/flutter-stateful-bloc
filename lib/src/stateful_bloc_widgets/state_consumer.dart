part of '../../flutter_stateful_bloc.dart';

/// A widget that rebuilds its child when a new state of type [ConsumedState] is emitted.
/// [ConsumedState] must be a subtype of [ContextState].
class StateConsumer<ConsumedState extends ContextState>
    extends StatelessWidget {
  const StateConsumer({
    super.key,
    required this.builder,
    required this.initialState,
  });

  // The function that is called to build the widget.
  final StateWidgetBuilder<ConsumedState> builder;

  /// The initial state of the [StateConsumer] if there is no old [ConsumedState] in the application.
  final ConsumedState initialState;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, ContextState>(
      buildWhen: (previous, current) {
        return current is ConsumedState && current != previous ||
            current is _GlobalInitialState;
      },
      builder: (BuildContext context, state) {
        if (state is _GlobalInitialState) {
          state = initialState;
        }

        if (state is! ConsumedState) {
          state =
              stateHolder.lastStateOfContextType(ConsumedState) ?? initialState;
        }

        return builder(
          context,
          state as ConsumedState,
        );
      },
    );
  }
}

typedef StateWidgetBuilder<State extends ContextState> = Widget Function(
  BuildContext context,
  State state,
);
