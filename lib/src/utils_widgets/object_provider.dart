part of '../../flutter_stateful_bloc.dart';

/// A public typedef for [RepositoryProvider] in bloc package..
typedef ObjectProvider<T> = RepositoryProvider<T>;

/// A public API for bloc's context extensions.
/// Their usage must be to read or watch an object injected to the tree by [ObjectProvider].
extension ObjectGrabber on BuildContext {
  T readObject<T>() => read<T>();

  T watchObject<T>() => watch<T>();
}
