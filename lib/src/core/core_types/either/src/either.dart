sealed class Either<T1, T2> {
  const Either();

  factory Either.left(T1 left) => Left._(left);
  factory Either.right(T2 right) => Right._(right);

  bool get isLeft => this is Left<T1, T2>;
  bool get isRight => this is Right<T1, T2>;
}

final class Left<T1, T2> extends Either<T1, T2> {
  const Left._(this.left);
  final T1 left;
}

final class Right<T1, T2> extends Either<T1, T2> {
  const Right._(this.right);
  final T2 right;
}
