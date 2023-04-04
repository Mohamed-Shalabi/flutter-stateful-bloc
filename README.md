# stateful_bloc

A Flutter project that wraps the `flutter_bloc` package to easify working with it.

## Overview

### The BLoC pattern has some restrictions, like:

- UI may affect **bloc** design, by:
    - You need to divide a **bloc** to multiple **blocs** to emit multiple **states**, or you will suffer from much boilerplate code.
    - You cannot depend on the same **states** from multiple **blocs**, which lead to merging **blocs** or other boilerplate code.
- **blocs** are not immutable, you can save data in them which breaks the pattern.
- You must write much boilerplate code to communicate with other **blocs** in the UI layer.

### Solution

The main reason for these restrictions is that you can consume the **blocs** not the **states**.

You can consume the **states** themselves independently of **blocs**.
This enables **state inheritance** feature, which means that:

- You can consume states sent from multiple **blocs**.

- No UI-dependent **bloc** design, as:
    - you can emit different **states** from the same **bloc**.
    - you can consume the same **state** that is emitted by different **blocs**.
    - You can consume some of the **states** of the same **bloc** without much boilerplate.

- There are **stateMappers** that enable emitting some states when others are emitted.

- You can get the last state of certain **super type**.


Other advantage is that **blocs** are immutable, so:

- **States** are stored totally outside of the **blocs**.

- No data is saved in the **blocs**, you get the data from outside the **blocs** and send them to the **states**.


Finally, **blocs** no longer depend on `BuildContext`. So, all **blocs** can be handled in your DI framework freely.

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
