extension ComposeExtension<Y, Z> on Z Function(Y) {
  Z Function(X) compose<X>(Y Function(X) innerFunction) => (value) => this(innerFunction(value));
}

extension OnExtension<Y, Z> on Z Function(Y, Y) {
  Z Function(X) on<X>(Y Function(X) innerFunction) =>
      (value) => this(innerFunction(value), innerFunction(value));
}

extension BlackBirdExtension<Y, Z> on Z Function(Y) {
  Z Function(X1, X2) blackBirdCompose<X1, X2>(Y Function(X1, X2) innerFunction) =>
      (value1, value2) => this(innerFunction(value1, value2));
}


extension ApExtension<X, Y, Z> on Z Function(X, Y) {
  Z Function(X) ap(Y Function(X) innerFunction) =>
      (value) => this(value, innerFunction(value));
}
