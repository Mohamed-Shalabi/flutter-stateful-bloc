part of '../../flutter_stateful_bloc.dart';

/// The type of the functions sent to [GlobalCubit.stateMappers] to map form one state to another.
typedef StateMapper<FirstState extends ContextState,
        SecondState extends ContextState>
    = SecondState Function(FirstState firstState);
