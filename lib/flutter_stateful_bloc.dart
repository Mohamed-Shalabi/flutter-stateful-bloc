library flutter_stateful_bloc;

import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart' as test;
import 'package:meta/meta.dart';
import 'package:diff_match_patch/diff_match_patch.dart';

part 'src/extendable_blocs/extendable_blocs.dart';
part 'src/global_blocs.dart';
part 'src/stateful_bloc_widgets/state_consumer.dart';
part 'src/stateful_bloc_widgets/state_listener.dart';
part 'src/stateful_bloc_widgets/stateful_bloc_provider.dart';
part 'src/utils/state_holder.dart';
part 'src/utils/state_mapper.dart';
part 'src/utils/state_observer.dart';
part 'src/utils_widgets/object_provider.dart';
part 'test/stateful_bloc_test.dart';
part 'test/state_test.dart';
