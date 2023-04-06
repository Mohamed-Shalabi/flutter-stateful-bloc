// ignore_for_file: deprecated_member_use_from_same_package

part of '../flutter_stateful_bloc.dart';

@Deprecated('Changed class name to ContextState')
typedef SuperState = ContextState;

@Deprecated('Changed class name to StatefulProvider')
typedef StatefulBlocProvider = StatefulProvider;

@Deprecated('Changed class name to StateConsumer')
typedef StatefulBlocConsumer<ConsumedState extends SuperState> = StateConsumer<ConsumedState>;

@Deprecated('Changed class name to StateListener')
typedef StatefulBlocListener<ListenedState extends SuperState> = StateListener<ListenedState>;

@Deprecated('Changed class name to StatelessCubit')
typedef StatefulCubit<State extends SuperState> = StatelessCubit<State>;
