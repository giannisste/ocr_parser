extension RecordMapExtension<X, Y> on (X, Y) {
  (X2, Y2) map<X2, Y2>(
    X2 Function(X first) function1,
    Y2 Function(Y second) function2,
  ) =>
      (function1($1), function2($2));

  (X2, Y) mapFirst<X2>(
    X2 Function(X first) function1,
  ) =>
      (function1($1), $2);

  (X, Y2) mapSecond<Y2>(
    Y2 Function(Y second) function2,
  ) =>
      ($1, function2($2));
}

extension RecordAsyncMapExtension<X, Y> on (X, Y) {
  Future<(X2, Y2)> asyncMap<X2, Y2>(
    Future<X2> Function(X first) function1,
    Future<Y2> Function(Y second) function2,
  ) =>
      (function1($1), function2($2)).wait;
}

extension RecordFoldExtension<X, Y> on (X, Y) {
  S fold<S>(S initialValue, S Function(X, S) firstFunction, S Function(Y, S) secondFunction) =>
      secondFunction($2, firstFunction($1, initialValue));
}

extension RecordMapExtension3<X, Y, Z> on (X, Y, Z) {
  (X2, Y2, Z2) map<X2, Y2, Z2>(
    X2 Function(X first) function1,
    Y2 Function(Y second) function2,
    Z2 Function(Z second) function3,
  ) =>
      (function1($1), function2($2), function3($3));

  (X2, Y, Z) mapFirst<X2>(
    X2 Function(X first) function1,
  ) =>
      (function1($1), $2, $3);

  (X, Y2, Z) mapSecond<Y2>(
    Y2 Function(Y second) function2,
  ) =>
      ($1, function2($2), $3);

  (X, Y, Z2) mapThird<Z2>(
    Z2 Function(Z third) function3,
  ) =>
      ($1, $2, function3($3));
}

extension RecordMapExtension4<X, Y, Z, W> on (X, Y, Z, W) {
  (X2, Y2, Z2, W2) map<X2, Y2, Z2, W2>(
    X2 Function(X first) function1,
    Y2 Function(Y second) function2,
    Z2 Function(Z second) function3,
    W2 Function(W second) function4,
  ) =>
      (function1($1), function2($2), function3($3), function4($4));

  (X2, Y, Z, W) mapFirst<X2>(
    X2 Function(X first) function1,
  ) =>
      (function1($1), $2, $3, $4);

  (X, Y2, Z, W) mapSecond<Y2>(
    Y2 Function(Y second) function2,
  ) =>
      ($1, function2($2), $3, $4);

  (X, Y, Z2, W) mapThird<Z2>(
    Z2 Function(Z third) function3,
  ) =>
      ($1, $2, function3($3), $4);

  (X, Y, Z, W2) mapFourth<W2>(
    W2 Function(W third) function4,
  ) =>
      ($1, $2, $3, function4($4));
}

extension RecordMapExtension5<X, Y, Z, W, Q> on (X, Y, Z, W, Q) {
  (X2, Y2, Z2, W2, Q2) map<X2, Y2, Z2, W2, Q2>(
    X2 Function(X first) function1,
    Y2 Function(Y second) function2,
    Z2 Function(Z second) function3,
    W2 Function(W second) function4,
    Q2 Function(Q second) function5,
  ) =>
      (function1($1), function2($2), function3($3), function4($4), function5($5));

  (X2, Y, Z, W) mapFirst<X2>(
    X2 Function(X first) function1,
  ) =>
      (function1($1), $2, $3, $4);

  (X, Y2, Z, W) mapSecond<Y2>(
    Y2 Function(Y second) function2,
  ) =>
      ($1, function2($2), $3, $4);

  (X, Y, Z2, W) mapThird<Z2>(
    Z2 Function(Z third) function3,
  ) =>
      ($1, $2, function3($3), $4);

  (X, Y, Z, W2) mapFourth<W2>(
    W2 Function(W third) function4,
  ) =>
      ($1, $2, $3, function4($4));

  (X, Y, Z, W, Q2) mapFifth<Q2>(
    Q2 Function(Q third) function5,
  ) =>
      ($1, $2, $3, $4, function5($5));
}

extension RecordToListExtension<X, Y> on (X, Y) {
  List<T> toList<T>(T Function(X first) function1, T Function(Y second) function2) =>
      [function1($1), function2($2)];
}

extension Record3ToListExtension<X, Y, Z> on (X, Y, Z) {
  List<T> toList<T>(
    T Function(X first) function1,
    T Function(Y second) function2,
    T Function(Z third) function3,
  ) =>
      [function1($1), function2($2), function3($3)];
}

extension Record4ToListExtension<X, Y, Z, W> on (X, Y, Z, W) {
  List<T> toList<T>(
    T Function(X first) function1,
    T Function(Y second) function2,
    T Function(Z third) function3,
    T Function(W fourth) function4,
  ) =>
      [function1($1), function2($2), function3($3), function4($4)];
}

extension Record5ToListExtension<X, Y, Z, W, Q> on (X, Y, Z, W, Q) {
  List<T> toList<T>(
    T Function(X first) function1,
    T Function(Y second) function2,
    T Function(Z third) function3,
    T Function(W fourth) function4,
    T Function(Q fifth) function5,
  ) =>
      [
        function1($1),
        function2($2),
        function3($3),
        function4($4),
        function5($5),
      ];
}

extension RecordStateExtension<X, Y> on (X, Y) {
  ((T, X), (T, Y)) withState<T>(T state) {
    return map((first) => (state, first), (second) => (state, second));
  }
}

extension Record3StateExtension<X, Y, Z> on (X, Y, Z) {
  ((T, X), (T, Y), (T, Z)) withState<T>(T state) {
    return map((first) => (state, first), (second) => (state, second), (third) => (state, third));
  }
}

extension Record4StateExtension<X, Y, Z, W> on (X, Y, Z, W) {
  ((T, X), (T, Y), (T, Z), (T, W)) withState<T>(T state) {
    return map(
      (first) => (state, first),
      (second) => (state, second),
      (third) => (state, third),
      (fourth) => (state, fourth),
    );
  }
}

extension Record5StateExtension<X, Y, Z, W, Q> on (X, Y, Z, W, Q) {
  ((T, X), (T, Y), (T, Z), (T, W), (T, Q)) withState<T>(T state) {
    return map(
      (first) => (state, first),
      (second) => (state, second),
      (third) => (state, third),
      (fourth) => (state, fourth),
      (fifth) => (state, fifth),
    );
  }
}
