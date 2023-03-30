part of '../global_bloc/global_cubit.dart';

class StatefulBlocConsumer<ConsumedState extends GlobalState> extends StatefulWidget {
  const StatefulBlocConsumer({super.key, required this.builder, required this.initialState});

  final StateWidgetBuilder<ConsumedState> builder;
  final ConsumedState initialState;

  @override
  State<StatefulBlocConsumer<ConsumedState>> createState() => _StatefulBlocConsumerState<ConsumedState>();
}

class _StatefulBlocConsumerState<ConsumedState extends GlobalState> extends State<StatefulBlocConsumer<ConsumedState>> {
  late ConsumedState state;

  @override
  void initState() {
    state = widget.initialState;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<_GlobalCubit, GlobalState, ConsumedState>(
      selector: (state) {
        if (state is ConsumedState) {
          return state;
        }

        return this.state;
      },
      builder: (BuildContext context, state) {
        return widget.builder(context, state);
      },
    );
  }
}

typedef StateWidgetBuilder<State extends GlobalState> = Widget Function(
  BuildContext context,
  State state,
);
