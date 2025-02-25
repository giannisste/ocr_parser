extension ZipWithExtension<T> on T {
  (T, S) zipWith<S>(S other) => (this, other);
}
