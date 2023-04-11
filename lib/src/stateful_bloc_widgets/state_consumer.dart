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

/// A widget that rebuilds its child when a new state of types [State1] or [State2] or [State3] is emitted.
/// These states must be of type of [ContextState].
class MixedStateConsumer<State1 extends ContextState,
    State2 extends ContextState> extends StatelessWidget {
  const MixedStateConsumer({
    super.key,
    required this.builder,
    required this.initialState1,
    required this.initialState2,
  });

  // The function that is called to build the widget.
  final MixedStateWidgetBuilder<State1, State2> builder;

  /// The initial state of the [State1] if there is no old [State1] in the application.
  final State1 initialState1;

  /// The initial state of the [State2] if there is no old [State2] in the application.
  final State2 initialState2;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, ContextState>(
      buildWhen: (previous, current) {
        return current is State1 && current != previous ||
            current is State2 && current != previous ||
            current is _GlobalInitialState;
      },
      builder: (BuildContext context, state) {
        if (state is _GlobalInitialState) {
          state = initialState1;
        }

        final State1 state1;
        final State2 state2;

        if (state is State1) {
          state1 = state;
          state2 = stateHolder.lastStateOfContextType(State2) as State2? ??
              initialState2;
        } else if (state is State2) {
          state1 = stateHolder.lastStateOfContextType(State1) as State1? ??
              initialState1;
          state2 = state;
        } else {
          state1 = initialState1;
          state2 = initialState2;
        }

        return builder(
          context,
          state,
          state1,
          state2,
        );
      },
    );
  }
}

typedef MixedStateWidgetBuilder<State1 extends ContextState,
        State2 extends ContextState>
    = Widget Function(
  BuildContext context,
  dynamic lastState,
  State1 state1,
  State2 state2,
);

/// A widget that rebuilds its child when a new state of types [State1] or [State2] or [State3] is emitted.
/// These states must be of type of [ContextState].
class MixedStateConsumer3<
    State1 extends ContextState,
    State2 extends ContextState,
    State3 extends ContextState> extends StatelessWidget {
  const MixedStateConsumer3({
    super.key,
    required this.builder,
    required this.initialState1,
    required this.initialState2,
    required this.initialState3,
  });

  // The function that is called to build the widget.
  final MixedStateWidgetBuilder3<State1, State2, State3> builder;

  /// The initial state of the [State1] if there is no old [State1] in the application.
  final State1 initialState1;

  /// The initial state of the [State2] if there is no old [State2] in the application.
  final State2 initialState2;

  /// The initial state of the [State3] if there is no old [State3] in the application.
  final State3 initialState3;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalCubit, ContextState>(
      buildWhen: (previous, current) {
        return current is State1 && current != previous ||
            current is State2 && current != previous ||
            current is State3 && current != previous ||
            current is _GlobalInitialState;
      },
      builder: (BuildContext context, state) {
        if (state is _GlobalInitialState) {
          state = initialState1;
        }

        final State1 state1;
        final State2 state2;
        final State3 state3;

        if (state is State1) {
          state1 = state;
          state2 = stateHolder.lastStateOfContextType(State2) as State2? ??
              initialState2;
          state3 = stateHolder.lastStateOfContextType(State3) as State3? ??
              initialState3;
        } else if (state is State2) {
          state1 = stateHolder.lastStateOfContextType(State1) as State1? ??
              initialState1;
          state2 = state;
          state3 = stateHolder.lastStateOfContextType(State3) as State3? ??
              initialState3;
        } else if (state is State3) {
          state1 = stateHolder.lastStateOfContextType(State1) as State1? ??
              initialState1;
          state2 = stateHolder.lastStateOfContextType(State2) as State2? ??
              initialState2;
          state3 = state;
        } else {
          state1 = initialState1;
          state2 = initialState2;
          state3 = initialState3;
        }

        return builder(
          context,
          state,
          state1,
          state2,
          state3,
        );
      },
    );
  }
}

typedef MixedStateWidgetBuilder3<State1 extends ContextState,
        State2 extends ContextState, State3 extends ContextState>
    = Widget Function(
  BuildContext context,
  dynamic lastState,
  State1 state1,
  State2 state2,
  State3 state3,
);
