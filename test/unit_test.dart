import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_stateful_bloc/flutter_stateful_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'context.dart';

void main() {
  group('unit test', () {
    setUp(() {
      stateObserver.setDefaultStateObserver((_, __) {});
    });
    tearDown(() {
      stateHolder.clear();
    });
    blocTest(
      'Testing GlobalCubit basic usage',
      build: () => GlobalCubit(
        [],
        stateHolder,
      ),
      act: (bloc) {
        stateHolder.addState(CounterIncrementState(1));
        stateHolder.addState(CounterIncrementState(2));
        stateHolder.addState(CounterDecrementState(1));
      },
      expect: () => [
        CounterIncrementState(1),
        CounterIncrementState(2),
        CounterDecrementState(1),
      ],
    );
    blocTest(
      'Should add state well even after calling close on GlobalCubit',
      build: () => GlobalCubit(
        [],
        stateHolder,
      ),
      act: (bloc) {
        bloc.close();
        stateHolder.addState(CounterIncrementState(1));
        stateHolder.addState(CounterIncrementState(2));
        stateHolder.addState(CounterDecrementState(1));
      },
      expect: () => [
        CounterIncrementState(1),
        CounterIncrementState(2),
        CounterDecrementState(1),
      ],
    );
    blocTest(
      'Testing state mappers',
      build: () => GlobalCubit(
        [
          StateMapper<CounterIncrementState, ThatWordState>(
            function: (CounterIncrementState firstState) => ThatWordState(),
          ),
          StateMapper<CounterDecrementState, ThisWordState>(
            function: (CounterDecrementState firstState) => ThisWordState(),
          ),
        ],
        stateHolder,
      ),
      act: (bloc) {
        stateHolder.addState(CounterIncrementState(1));
        stateHolder.addState(CounterDecrementState(0));
      },
      expect: () => [
        CounterIncrementState(1),
        ThatWordState(),
        CounterDecrementState(0),
        ThisWordState(),
      ],
    );
  });
  group(
    'Testing state holder',
    () {
      setUp(() async {
        final cubit = GlobalCubit(
          [],
          stateHolder,
        );
        stateHolder.addState(CounterIncrementState(1));
        stateHolder.addState(CounterDecrementState(0));
        Future.delayed(
          const Duration(seconds: 2),
          () {
            cubit.cancelStream();
          },
        );
        await cubit.stream.toList();
      });
      test(
        'Testing state holders',
        () {
          final state = stateHolder.lastStateOfContextType<CounterStates>();
          expect(state, CounterDecrementState(0));
        },
      );
    },
  );
}
