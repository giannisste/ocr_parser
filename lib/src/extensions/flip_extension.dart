extension FlipExtension<X, Y> on (X, Y) {
  (Y, X) flip() => (this.$2, this.$1);
}
