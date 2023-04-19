part of '../../flutter_stateful_bloc.dart';

/// The type of the functions sent to [GlobalCubit.stateMappers] to map form one state to another.
typedef StateMapped<FirstState extends ContextState,
        SecondState extends ContextState>
    = SecondState Function(FirstState firstState);

/// The class send to [StatefulProvider.stateMappers].
@immutable
class StateMapper<FirstState extends ContextState,
    SecondState extends ContextState> {
  const StateMapper({
    required this.function,
  }) : _type = FirstState;

  final Type _type;
  final StateMapped<FirstState, SecondState> function;

  SecondState call(FirstState firstState) {
    return function(firstState);
  }
}
