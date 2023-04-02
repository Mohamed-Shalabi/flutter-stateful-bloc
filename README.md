# stateful_bloc

A Flutter project that wraps the `flutter_bloc` package to easify working with it.

## Overview

### To easify working with **cubits** and **states**, we provided:

- Easifying working with states, by:
    - Making UI rebuilding depend on **states** only, not the **cubit** itself.
    - You can depend on **states** in any widget in the tree.
    - You can depend on different states in the same widget.
    - You can map a state of certain type to a state of another type which will rebuild and be listened by both widgets.
    - All cubits are owned by you, you can handle them in a DI framework as you need.
    - You can trace any **state** changes.
    - You can get the last state of certain **super type**.

- Making **cubits** more flexible, through:
    - Ensuring that the UI gets data from the **states** only, not the cubit itself.
    - All the **cubits** should be immutable.
    - No need to inject the **cubits** to the UI by the **BlocProvider**, with the ability to separate the **cubits** without the headache of taking care of the widget tree.

## Getting Started

- Wrap your app with ***StatefulBlocProvider***.
- Create your states that extend ***ExtendableState***.
- Create **stateMappers** in the ***StatefulBlocProvider*** constructor if you need to map certain states to other type.
- In your **super state** override **superStates** getter and add the current state type.
- You can add more **super states** to the **superStates** getter if you need to depend on multiple **super states** for the same widget.
- Create your cubit that extends ***StatefulCubit***.
- Wrap your UI that depends on the cubit with ***StatefulBlocConsumer*** to rebuild depending on the states.
- Wrap the body of the **Scaffold** with ***StatefulBlocListener*** to listen to states. 
- Create an instance of your cubit and enjoy :)
- You can make actions when state changes using **stateObserver**.
- You can access last **states** of each **super state** using **stateHolder**.

## Testing:

- For minimalization, you can test your **cubits** manually and check the **states** using **stateHolder**.
- There is also ***statefulBlocTest*** function that acts like ***blocTest*** in **bloc_test** package.

## NOTES:

- All cubits and states must be immutable with const constructors.
- The ***StatefulBlocConsumer*** won't rebuild except if the emitted state is of its generic type or its children.
- The package won't be published before completing development and testing, because it is still unstable.

## Examples:

Comming soon.

## TODOs:

- Changing package name to stateful_cubit.
- Writing rich documentation.
