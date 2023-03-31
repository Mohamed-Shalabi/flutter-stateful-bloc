# stateful_bloc

A Flutter project that wraps the `flutter_bloc` package to easify working with it by:

- Ensuring that the UI gets data from the **states** only, not the cubit itself, by making all the **states** and **cubits** immutable.
- You can depend on different states in the same widget by inheritance hierarchy.
- You can emit any state from any cubit, no need to make BLoC-to-BLoC Communication.
- No need to inject the **cubits** to the UI by the **BlocProvider**, with the ability to separate the **cubits** without the headache of taking care of the widget tree.
- All cubits are owned by you, you can handle them in a DI framework as you need.

## Getting Started

### To get started:

- Wrap your app with ***StatefulBlocProvider***.
- Create your states that extend ***ExtendableState***.
- Create your cubit that extends ***StatefulCubit***.
- Wrap your UI that depends on the cubit with ***StatefulBlocConsumer*** to rebuild depending on the states.
- Wrap the body of the **Scaffold** with ***StatefulBlocListener*** to listen to states. 
- Create an instance of your cubit and enjoy :)

## NOTES:

- All cubits and states must be immutable with const constructors.
- The ***StatefulBlocConsumer*** won't rebuild except if the emiitted state is of its generic type or its children.
- The package won't be published before completing development and testing, because it is still unstable.

## TODO list:

- Changing package name to stateful_cubit.
- Making errors traceable.
- Writing rich documentation.
