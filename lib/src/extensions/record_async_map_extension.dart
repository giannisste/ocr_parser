extension RecordMapExtension<X, Y> on (X, Y) {
  Future<(X2, Y2)> asyncMap<X2, Y2>(
    Future<X2> Function(X first) function1,
    Future<Y2> Function(Y second) function2,
  ) =>
      (function1($1), function2($2)).wait;
}
