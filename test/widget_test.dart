import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stateful_bloc/flutter_stateful_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'context.dart';

void main() {
  group(
    'widget test',
    () {
      setUp(() {
        stateObserver.setDefaultStateObserver((_, __, ___) {});
      });
      tearDown(() {
        stateHolder.clear();
      });
      testWidgets(
        'Verifying that GlobalCubit is injected to the tree',
        (widgetTester) async {
          await widgetTester.pumpWidget(const MyApp());

          final homeFinder = find.byType(MyHomePage);
          final context = widgetTester.element(homeFinder);
          final cubit = context.read<GlobalCubit?>();
          expect(cubit, isNotNull);
        },
      );
      testWidgets(
        'Verifying that StateConsumer and MixedStateConsumer rebuild the UI',
        (widgetTester) async {
          await widgetTester.pumpWidget(const MyApp());

          expect(find.textContaining('0'), findsNWidgets(2));
          stateHolder.addState(CounterIncrementState(1));
          await widgetTester.pump();
          expect(find.textContaining('1'), findsNWidgets(2));
          stateHolder.addState(CounterDecrementState(0));
          await widgetTester.pump();
          expect(find.textContaining('0'), findsNWidgets(2));
          stateHolder.addState(CounterDecrementState(-1));
          await widgetTester.pump();
          expect(find.textContaining('-1'), findsNWidgets(2));
        },
      );
      testWidgets(
        'Verifying that StateListener listens to states',
        (widgetTester) async {
          await widgetTester.pumpWidget(const MyApp());

          stateHolder.addState(CounterIncrementState(1));
          await widgetTester.pump();
          expect(find.byType(SnackBar), findsOneWidget);
          expect(find.text('new value'), findsOneWidget);
          stateHolder.addState(CounterDecrementState(0));
          await widgetTester.pump();
          expect(find.byType(SnackBar), findsOneWidget);
          expect(find.text('new value'), findsOneWidget);
          stateHolder.addState(CounterDecrementState(-1));
          await widgetTester.pump();
          expect(find.byType(SnackBar), findsOneWidget);
          expect(find.text('new value'), findsOneWidget);
        },
      );
    },
  );
}
