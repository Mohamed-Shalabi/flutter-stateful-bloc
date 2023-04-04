# stateful_bloc

A Flutter project that wraps the `flutter_bloc` package to easify working with it.

## Overview

**The BLoC pattern has some restrictions, like:**

- UI may affect **bloc** design
    - You need to divide a **bloc** to multiple **blocs** to emit multiple **states** if they are not physically dependent even if they are logically related, or you will suffer from much boilerplate code.
    - You cannot depend on the same **states** from multiple **blocs**, which lead to merging **blocs** or other boilerplate code.
- **blocs** are not immutable, you can save data in them which is not safe and breaks the pattern.
- You must write much boilerplate code to communicate with other **blocs** in the UI layer.

### Solution

The main reason for these restrictions is that you can consume the **blocs** not the **states**.

`flutter_stateful_bloc` lets you consume the **states** themselves independently of **blocs**.

This enables **state mixing** feature, which means that:

- You can consume states sent from multiple **blocs**.
- No UI-dependent **bloc** design, as the **bloc** become only a set of methods that emit states as they are immutable.
- There are **stateMappers** that enable emitting some states when others are emitted.
- You can get the last state of certain **super type**.

Other advantage is that our **blocs** are immutable, so:
- **States** are stored totally outside of the **blocs**.
- No data is saved in the **blocs**, you get the data from outside the **blocs** and send them to the **states**.

Finally, **blocs** no longer depend on `BuildContext`. So, all **blocs** can be handled in your DI framework freely.

## Usage

The example explains how to use `stateful_bloc` in a simple bluetooth application that listens to connection status and sends data via bluetooth.

### Basic usage

- Wrap your app with ***StatefulBlocProvider***.
```dart
@override
Widget build(BuildContext context) {
  return StatefulBlocProvider(
    app: MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppColors.purple,
      ),
      home: const HomeScreen(),
    ),
  );
}
```
- Create your **super state** that implements ***SuperState***, and add its type to the **superStates** getter.
- Make getters for the data you need, it is preferred to use getters over class members.
```dart
abstract class ConnectionStates implements SuperState {
  bool get isConnected;

  @override
  List<Type> get superStates => [ConnectionStates];
}
```
- create your **states** that mix the **super state**.
```dart
class ConnectionConnectedState with ConnectionStates {
  @override
  bool get isConnected => true;
}

class ConnectionDisconnectedState with ConnectionStates {
  @override
  bool get isConnected => false;
}
```
- Create your cubit that extends ***StatefulCubit***.
```dart
class ConnectionCubit extends StatefulCubit<ConnectionStates> {
  ConnectionCubit({
    required ConnectionStreamUseCase connectionStreamUseCase,
  }) {
    _subscribeToConnectionState(connectionStreamUseCase);
  }

  void _subscribeToConnectionState(
    ConnectionStreamUseCase connectionStreamUseCase,
  ) {
    connectionStreamUseCase().listen(
      (connectionStateEntity) {
        final isConnected = connectionStateEntity.isConnected;

        if (isConnected) {
          emit(ConnectionConnectedState());
        } else {
          emit(ConnectionDisconnectedState());
        }
      },
    );
  }
}
```
- Wrap your UI that depends on the cubit with ***StatefulBlocConsumer***. 

```dart
@override
Widget build(BuildContext context) {
  return StatefulBlocConsumer<ConnectionStates>(
    initialState: stateHolder.lastStateOfSuperType(ConnectionStates) ?? ConnectionDisconnectedState(),
    builder: (BuildContext context, ConnectionStates state) {
      return Text('Connected: ${state.isConnected}');
    },
  );
}
```
You will need to provide an initial state. You can get the last emitted state of your **super type** like this:
```dart
@override
Widget build(BuildContext context) {
  return StatefulBlocConsumer<ConnectionStates>(
    initialState: stateHolder.lastStateOfSuperType(ConnectionStates) ?? ConnectionDisconnectedState(),
    builder: (BuildContext context, ConnectionStates state) {
      return Text('Connected: ${state.isConnected}');
    },
  );
}
```

- Wrap the body of the **Scaffold** with ***StatefulBlocListener*** to listen to states (for example, to show messages).
```dart
return Scaffold(
  appBar: AppBar(
    title: const Text('Home'),
  ),
  body: StatefulBlocListener<SuperState>(
    listener: (context, state) {
      if (state is ConnectionConnectedState) {
        context.showSnackBar('Connected');
      }

      if (state is ConnectionDisconnectedState) {
        context.showSnackBar('Disconnected');
      }
    },
    body: ...
  ),
);
```

- Create an instance of ConnectionCubit, and use it.

And you are done!

### State Mixing

Imagine that the previous `Text` widget shows a message for 3 seconds when sending messages fails or succeeds.

The logic of showing different states is done outside of the UI, but the `Text` widget needs to consume different states now.

- The messaging states
```dart
abstract class MessagingStates implements SuperState {
  @override
  List<Type> get superStates => [MessagingStates];
}

class MessagingSuccessState extends MessagingStates {
  final String message;

  // constructor..
}

class MessagingFailedState extends MessagingStates {
  final String errorMessage;

  // constructor..
}
```

*How can we consume both states in the same widget?*

- Create a new **super state**.
```dart
abstract class TextState implements SuperState {
  String get text;

  @override
  List<Type> get superStates => [TextState];
}
```
- Modify old **super states**:
```dart
abstract class MessagingStates with TextState {
  @override
  List<Type> get superStates => [MessagingStates, TextState];
}

abstract class ConnectionStates with TextState {
  final bool isConnected;

  // constructor..

  @override
  String get text => isConnected ? 'Connected' : 'Not connected';

  @override
  List<Type> get superStates => [ConnectionStates, TextState];
}
```
- Now, you will need to implement the text getter in the concrete `MessagingStates`
```dart
class MessagingSuccessState extends MessagingStates {
  final String message;

  // constructor..

  @override
  String get text => message;
}

class MessagingFailedState extends MessagingStates {
  final String errorMessage;

  // constructor..

  @override
  String get text => errorMessage;
}
```
- Finally, edit the widget to consume the new **super state**
```dart
@override
Widget build(BuildContext context) {
  return StatefulBlocConsumer<TextStates>(
    initialState: stateHolder.lastStateOfSuperType(TextStates) ?? ConnectionDisconnectedState(),
    builder: (BuildContext context, TextStates state) {
      return Text(state.text);
    },
  );
}
```

### State Mappers
Imagine that you need to emit a concrete **state** of type ***A*** when a concrete state of type ***B*** is emitted.

If these **states** hold data, they cannot be mixed to each other.

To overcome this issue, there are **stateMappers**!

Modify the `StatefulBlocProvider` to be:

```dart
@override
Widget build(BuildContext context) {
  return StatefulBlocProvider(
    stateMappers: [
      A: [(A a) => B(a.data)],
      B: [(B b) => A(b.data)],
    ],
    app: ...
  );
}
```

Now, any state of type ***A***, which is concrete, will emit a state of type ***B*** and vice versa.

You can make a single mapper.

***NOTE:*** **state mappers** work on a single level mapping. So, the mapped states won't be mapped again and again.

## Utils

### State Observer

- You can trace **states** by using the function `setDefaultStateObserver` in the `stateObserver` getter.
```dart
  stateObserver.setDefaultStateObserver((
    Type superState,
    SuperState previous,
    SuperState current,
  ) {
    if (kDebugMode) {
      print(
        'Scope $superState: '
        'Transitioning from ${previous.runtimeType} '
        'to ${current.runtimeType}',
      );
    }
  });
```
- You can trace **states** of certain type by using the function `setStateObserver` in the `stateObserver` getter.
```dart
stateObserver.setStateObserver(
  MessagingStates, 
  (
    Type superState,
    SuperState previous,
    SuperState current,
  ) {
    if (kDebugMode) {
      print(
        'Scope $superState: '
        'Transitioning from ${previous.runtimeType} '
        'to ${current.runtimeType}',
      );
    }
  },
);
```

### State Holder

- You can access last **states** of each **super state** using **stateHolder**.
```dart
final lastTextState = stateHolder.lastStateOfSuperType(TextState);
```

## Testing

- For minimalization, you can test your **cubits** manually and check the **states** using **stateHolder**.
- There is also ***statefulBlocTest*** function that acts like ***blocTest*** in **bloc_test** package.

## NOTES

- All cubits and states should be immutable.
- The ***StatefulBlocConsumer*** won't rebuild except if the emitted state is of its generic type or its children.
- The package won't be published before completing development and testing, because it is still unstable.

## Examples

Comming soon.
