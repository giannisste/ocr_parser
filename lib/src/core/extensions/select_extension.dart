import '../core_types/either/either.dart';

extension SelectExtension<T> on T {
  S foldBool<S>(
    bool Function(T) condition,
    S Function(T) lefFunction,
    S Function(T) rightFunction,
  ) =>
      condition(this) ? lefFunction(this) : rightFunction(this);

  Either<T1, T2> select<T1, T2>(
    bool Function(T) condition,
    T1 Function(T) lefFunction,
    T2 Function(T) rightFunction,
  ) =>
      foldBool(
        condition,
        (left) => Either.left(lefFunction(left)),
        (right) => Either.right(rightFunction(right)),
      );

  Future<Either<T1, T2>> asyncLeftSelect<T1, T2>(
    bool Function(T) condition,
    Future<T1> Function(T) lefFunction,
    T2 Function(T) rightFunction,
  ) async =>
      condition(this)
          ? Either.left(await lefFunction(this))
          : Either.right(rightFunction(this));

  Future<Either<T1, T2>> asyncSelect<T1, T2>(
    bool Function(T) condition,
    Future<T1> Function(T) lefFunction,
    Future<T2> Function(T) rightFunction,
  ) async =>
      condition(this)
          ? Either.left(await lefFunction(this))
          : Either.right(await rightFunction(this));
}

extension EitherFuture<T1, T2> on Either<Future<T1>, Future<T2>> {
  Future<Either<T1, T2>> wait() => asyncFold(
        (left) async => Either.left(await left),
        (right) async => Either.right(await right),
      );
}
