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
        'Verifying that StatefulBlocConsumer rebuilds the UI',
        (widgetTester) async {
          await widgetTester.pumpWidget(const MyApp());

          expect(find.text('0'), findsOneWidget);
          stateHolder.addState(CounterIncrementState(1));
          await widgetTester.pump();
          expect(find.text('1'), findsOneWidget);
          stateHolder.addState(CounterDecrementState(0));
          await widgetTester.pump();
          expect(find.text('0'), findsOneWidget);
          stateHolder.addState(CounterDecrementState(-1));
          await widgetTester.pump();
          expect(find.text('-1'), findsOneWidget);
        },
      );
      testWidgets(
        'Verifying that StatefulBlocListener listens to states',
        (widgetTester) async {
          await widgetTester.pumpWidget(const MyApp());

          stateHolder.addState(CounterIncrementState(1));
          await widgetTester.pump();
          expect(find.byType(SnackBar), findsOneWidget);
          expect(find.text('new value: 1'), findsOneWidget);
          stateHolder.addState(CounterDecrementState(0));
          await widgetTester.pump();
          expect(find.byType(SnackBar), findsOneWidget);
          expect(find.text('new value: 0'), findsOneWidget);
          stateHolder.addState(CounterDecrementState(-1));
          await widgetTester.pump();
          expect(find.byType(SnackBar), findsOneWidget);
          expect(find.text('new value: -1'), findsOneWidget);
        },
      );
    },
  );
}
