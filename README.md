# flutter_stateful_bloc

![GitHub](https://img.shields.io/github/license/Mohamed-Shalabi/flutter-stateful-bloc)

## Overview

A Flutter package that wraps the `flutter_bloc` package to easify working with it.

This is a (stateful)(bloc_package) not (stateful_bloc)(package). The reason for this name is that we made states totally independent of blocs. We use the concept of **stateless blocs**.

## Migration

From 0.0.6-beta to 0.1.0-beta, we renamed:
- `SuperState` to `ContextState`.
- `superStates` getter in `SuperState` to `parentStates` getter in `ContextState`.
- `StatefulCubit` to `StatelessCubit` (it was a bad name).
- `StatefulBlocProvider` to `StatefulProvider`.
- `StatefulBlocConsumer` to `StateConsumer`.
- `StatefulBlocListener` to `StateListener`.

## The Problem

**The BLoC pattern has some restrictions, like:**

- UI may affect **bloc** design
    - You need to divide a **bloc** to multiple **blocs** to emit multiple **states** if they are not physically dependent even if they are logically related, or you will suffer from much boilerplate code.
    - You cannot depend on the same **states** from multiple **blocs**, which lead to merging **blocs** or other boilerplate code.
- **blocs** are not immutable, you can save data in them which is not safe and breaks the pattern.
- You must write much boilerplate code to communicate with other **blocs** in the UI layer.

### Terminology

- **Context States**: 
    - Classes that implement `ContextState`.
    - They should contain abstract getters for their data.
    - They are usually mixed to the ordinary **states** and can be mixed to each other.
- **State Mixing**:
    - The feature of mixing multiple **states** into a single state that holds one snapshot of data a time.
- **Stateless BLoCs**:
    - *BLoC*s that don't hold **states**.
- **State Mappers**:
    - The feature of emitting certain **states** when other certain **states** are emitted.
- **State Holder**:
    - a Dart object that holds all the emitted **states**.

### Solution
The solution is **state mixing** feature, which means that:

- You can consume states sent from multiple **blocs**.
- No UI-dependent **bloc** design, as the **bloc** become only a set of methods that emit states as they are immutable.
- There are **stateMappers** that enable emitting some states when others are emitted.
- You can get the last state of certain **parent type**.

Other advantage is that our **blocs** are immutable, so:
- **States** are stored totally outside of the **blocs**.
- No data is saved in the **blocs**, you get the data from outside the **blocs** and send them to the **states**.

Finally, **blocs** no longer depend on `BuildContext`. So, all **blocs** can be handled in your DI framework freely.

*How is that done?*

The main reason for BLoC restrictions is that you can consume the **blocs** not the **states**.

`flutter_stateful_bloc` lets you consume the **states** themselves independently of **blocs**.

## Usage

The example explains how to use `stateful_bloc` in a simple bluetooth application that listens to connection status and sends data via bluetooth.

### Basic usage

- Wrap your app with ***StatefulProvider***.
```dart
@override
Widget build(BuildContext context) {
  return StatefulProvider(
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
- Create your **context state** that implements ***ContextState***, and add its type to the **parentStates** getter.
- Make getters for the data you need, it is preferred to use getters over class members.
```dart
abstract class ConnectionStates implements ContextState {
  bool get isConnected;

  @override
  List<Type> get parentStates => [ConnectionStates];
}
```
- create your **states** that mix the **context state**.
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
- Create your cubit that extends ***StatelessCubit***.
```dart
class ConnectionCubit extends StatelessCubit<ConnectionStates> {
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
- Wrap your UI that depends on the cubit with ***StateConsumer***. 

```dart
@override
Widget build(BuildContext context) {
  return StateConsumer<ConnectionStates>(
    initialState: ConnectionDisconnectedState(),
    builder: (BuildContext context, ConnectionStates state) {
      return Text('Connected: ${state.isConnected}');
    },
  );
}
```
You will need to provide an initial state. You can get the last emitted state of your **parent type** like this:
```dart
@override
Widget build(BuildContext context) {
  return StateConsumer<ConnectionStates>(
    initialState: stateHolder.lastStateOfParentType(ConnectionStates) ?? ConnectionDisconnectedState(),
    builder: (BuildContext context, ConnectionStates state) {
      return Text('Connected: ${state.isConnected}');
    },
  );
}
```

- Wrap the body of the **Scaffold** with ***StateListener*** to listen to states (for example, to show messages).
```dart
return Scaffold(
  appBar: AppBar(
    title: const Text('Home'),
  ),
  body: StateListener<ContextState>(
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
abstract class MessagingStates implements ContextState {
  @override
  List<Type> get parentStates => [MessagingStates];
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

- Create a new **context state**.
```dart
abstract class TextState implements ContextState {
  String get text;

  @override
  List<Type> get parentStates => [TextState];
}
```
- Modify old **context states**:
```dart
abstract class MessagingStates implements TextState {
  @override
  List<Type> get parentStates => [MessagingStates, TextState];
}

abstract class ConnectionStates with TextState {
  final bool isConnected;

  // constructor..

  @override
  String get text => isConnected ? 'Connected' : 'Not connected';

  @override
  List<Type> get parentStates => [ConnectionStates, TextState];
}
```
- Now, you will need to implement the text getter in the concrete `MessagingStates`
```dart
class MessagingSuccessState with MessagingStates {
  final String message;

  // constructor..

  @override
  String get text => message;
}

class MessagingFailedState with MessagingStates {
  final String errorMessage;

  // constructor..

  @override
  String get text => errorMessage;
}
```
Note that if you need to use `stateHolder.lastStateOfParentType` method in the state, you should make it as a member variable and initiate it in the constructor.
- Finally, edit the widget to consume the new **context state**
```dart
@override
Widget build(BuildContext context) {
  return StateConsumer<TextStates>(
    initialState: stateHolder.lastStateOfParentType(TextStates) ?? ConnectionDisconnectedState(),
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

Modify the `StatefulProvider` to be:

```dart
@override
Widget build(BuildContext context) {
  return StatefulProvider(
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
    Type contextState,
    ContextState previous,
    ContextState current,
  ) {
    if (kDebugMode) {
      print(
        'Scope $contextState: '
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
    Type contextState,
    ContextState previous,
    ContextState current,
  ) {
    if (kDebugMode) {
      print(
        'Scope $contextState: '
        'Transitioning from ${previous.runtimeType} '
        'to ${current.runtimeType}',
      );
    }
  },
);
```

### State Holder

- You can access last **states** of each **context state** using **stateHolder**.
```dart
final lastTextState = stateHolder.lastStateOfParentType(TextState);
```

## Testing

- For minimalization, you can test your **cubits** manually and check the **states** using **stateHolder**.
- There is also ***statefulBlocTest*** function that acts like ***blocTest*** in **bloc_test** package.

## NOTES

- **Context states** must be abstract classes that ***implement (not mix or extend)*** other **context states**.
- If you cannot mix a **context state** in a **concrete state**, then convert all constructor fields in the **context state** to getters.
- All cubits and states should be immutable.
- The ***StateConsumer*** won't rebuild except if the emitted state is of its generic type or its children.

## Examples

- [EOC-Manager](https://github.com/Mohamed-Shalabi/EOC-Manager/tree/with-stateful-bloc)
- More is comming soon.
