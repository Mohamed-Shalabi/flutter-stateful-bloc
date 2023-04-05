part of '../../flutter_stateful_bloc.dart';

typedef ObjectProvider<T> = RepositoryProvider<T>;

extension ObjectGrabber on BuildContext {
  T readObject<T>() => read<T>();

  T watchObject<T>() => watch<T>();
}
