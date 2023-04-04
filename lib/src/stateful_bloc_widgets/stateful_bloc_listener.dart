part of '../../stateful_bloc.dart';

/// A widget that executes [listener] function when a new state of type [ListenedState] is emitted.
class StatefulBlocListener<ListenedState extends SuperState>
    extends StatelessWidget {
  const StatefulBlocListener({
    super.key,
    required this.listener,
    required this.body,
  });

  final StateWidgetListener<ListenedState> listener;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    if (ListenedState == dynamic) {
      throw 'You must enter the states you need to listen to';
    }

    return BlocListener<_GlobalCubit, SuperState>(
      listenWhen: (previous, current) {
        return current is ListenedState && current != previous;
      },
      listener: (context, state) {
        if (state is ListenedState) {
          listener(context, state);
        }
      },
      child: body,
    );
  }
}

typedef StateWidgetListener<ListenedState extends SuperState> = void
    Function(BuildContext context, ListenedState state);
