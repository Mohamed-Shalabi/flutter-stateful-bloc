part of '../../flutter_stateful_bloc.dart';

/// The type of the functions sent to [GlobalCubit.stateMappers] to map form one state to another.
typedef StateMapped<FirstState extends ContextState,
        SecondState extends ContextState>
    = SecondState Function(FirstState firstState);

/// The class sent to [StatefulProvider.stateMappers].
class StateMapper<FirstState extends ContextState,
    SecondState extends ContextState> {
  StateMapper({
    required this.function,
  }) : _type = FirstState {
    if (SecondState == ContextState) {
      throw 'You must entre generic types';
    }
  }

  final Type _type;
  final StateMapped<FirstState, SecondState> function;

  SecondState call(FirstState firstState) {
    return function(firstState);
  }
}
