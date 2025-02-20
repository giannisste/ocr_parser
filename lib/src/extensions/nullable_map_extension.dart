extension NullableMapExtension<T> on T? {
  S nullableMap<S>(S Function(T) nonNullFunction, {required S whenNull}) {
    return switch (this) {
      null => whenNull,
      _ => nonNullFunction(this as T),
    };
  }

  S? foldNull<S>(S? Function(T) function) => this != null ? function(this as T) : null;
}
