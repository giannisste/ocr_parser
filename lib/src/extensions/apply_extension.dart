extension ApplyExtension<T, R> on R Function(T) {
  R apply(T argument) => this(argument);
}

extension Apply2Extension<T1, T2, R> on R Function(T1, T2) {
  R apply((T1, T2) tuple) => this(tuple.$1, tuple.$2);
}

extension Apply3Extension<T1, T2, T3, R> on R Function(T1, T2, T3) {
  R apply((T1, T2, T3) triple) => this(triple.$1, triple.$2, triple.$3);
}
