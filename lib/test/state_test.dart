part of '../flutter_stateful_bloc.dart';

/// Edited version of [blocTest] in package:test_bloc.
@isTest
void stateTest<State extends ContextState>(
  String description, {
  FutureOr<void> Function()? setUp,
  required List<StatelessCubit<State>> Function() buildCubits,
  Function(List<StatelessCubit> cubits)? act,
  Duration? wait,
  int skip = 0,
  dynamic Function()? expect,
  Function(List<State> states)? verify,
  dynamic Function()? errors,
  FutureOr<void> Function()? tearDown,
}) {
  test.test(
    description,
    () async {
      var shallowEquality = false;
      final unhandledErrors = <Object>[];

      await runZonedGuarded(
        () async {
          await setUp?.call();
          final states = <State>[];
          final cubits = buildCubits();
          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
          var globalCubit = getGlobalCubitInstance([]);
          final subscription = globalCubit.stream.skip(skip).listen(
            (state) {
              if (state is State) {
                states.add(state);
              }
            },
          );
          try {
            await act?.call(cubits);
          } catch (error) {
            if (errors == null) rethrow;
            unhandledErrors.add(error);
          }
          if (wait != null) await Future<void>.delayed(wait);
          await Future<void>.delayed(Duration.zero);
          await globalCubit.close();
          if (expect != null) {
            final dynamic expected = expect();
            shallowEquality = '$states' == '$expected';
            try {
              test.expect(states, test.wrapMatcher(expected));
            } on test.TestFailure catch (e) {
              if (shallowEquality || expected is! List<State>) rethrow;
              final diff = _diff(expected: expected, actual: states);
              final message = '${e.message}\n$diff';
              // ignore: only_throw_errors
              throw test.TestFailure(message);
            }
          }
          await subscription.cancel();
          await verify?.call(states);
          await tearDown?.call();
        },
        (Object error, _) {
          if (shallowEquality && error is test.TestFailure) {
            // ignore: only_throw_errors
            throw test.TestFailure(
              '''${error.message}
WARNING: Please ensure state instances extend Equatable, override == and hashCode, or implement Comparable.
Alternatively, consider using Matchers in the expect of the blocTest rather than concrete state instances.\n''',
            );
          }
          if (errors == null || !unhandledErrors.contains(error)) {
            // ignore: only_throw_errors
            throw error;
          }
        },
      );
      if (errors != null) {
        test.expect(unhandledErrors, test.wrapMatcher(errors()));
      }
    },
  );
}

// Copied from package:test_bloc
String _diff({required dynamic expected, required dynamic actual}) {
  final buffer = StringBuffer();
  final differences = diff(expected.toString(), actual.toString());
  buffer
    ..writeln('${"=" * 4} diff ${"=" * 40}')
    ..writeln('')
    ..writeln(differences.toPrettyString())
    ..writeln('')
    ..writeln('${"=" * 4} end diff ${"=" * 36}');
  return buffer.toString();
}

extension on List<Diff> {
  String toPrettyString() {
    String identical(String str) => '\u001b[90m$str\u001B[0m';
    String deletion(String str) => '\u001b[31m[-$str-]\u001B[0m';
    String insertion(String str) => '\u001b[32m{+$str+}\u001B[0m';

    final buffer = StringBuffer();
    for (final difference in this) {
      switch (difference.operation) {
        case DIFF_EQUAL:
          buffer.write(identical(difference.text));
          break;
        case DIFF_DELETE:
          buffer.write(deletion(difference.text));
          break;
        case DIFF_INSERT:
          buffer.write(insertion(difference.text));
          break;
      }
    }
    return buffer.toString();
  }
}
