extension SwapExtension<X, Y> on (X, Y) {
  (Y, X) get swap => ($2, $1);
}
