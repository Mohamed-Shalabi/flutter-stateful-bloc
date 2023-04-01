part of '../../stateful_bloc.dart';

typedef StateMapper<FirstState extends ExtendableState,
        SecondState extends ExtendableState>
    = SecondState Function(FirstState firstState);
