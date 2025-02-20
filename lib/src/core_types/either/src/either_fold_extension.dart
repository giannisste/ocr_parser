import 'either.dart';

extension EitherFoldExtension<X, Y> on Either<X, Y> {
  S fold<S>(
    S Function(X left) leftFunction,
    S Function(Y right) rightFunction,
  ) =>
      switch (this) {
        Left(:final left) => leftFunction(left),
        Right(:final right) => rightFunction(right),
      };

  Future<S> asyncFold<S>(
    Future<S> Function(X left) leftFunction,
    Future<S> Function(Y right) rightFunction,
  ) async =>
      switch (this) {
        Left(:final left) => await leftFunction(left),
        Right(:final right) => await rightFunction(right),
      };

  Either<X2, Y2> map<X2, Y2>(
    X2 Function(X left) leftFunction,
    Y2 Function(Y right) rightFunction,
  ) =>
      fold(
        (left) => Either.left(leftFunction(left)),
        (right) => Either.right(rightFunction(right)),
      );

  Either<X2, Y> mapLeft<X2>(
    Either<X2, Y> Function(X left) leftFunction,
  ) =>
      fold(leftFunction, Either.right);

  Either<Y, X> get reversed => fold(
        Either.right,
        Either.left,
      );

  Future<Either<X2, Y>> asyncMapLeft<X2>(
    Future<Either<X2, Y>> Function(X right) leftFunction,
  ) async =>
      switch (this) {
        Left(:final left) => await leftFunction(left),
        Right(:final right) => Either.right(right),
      };

  Either<X, Y2> mapRight<Y2>(
    Either<X, Y2> Function(Y right) rightFunction,
  ) =>
      fold(Either.left, rightFunction);

  Future<Either<X, Y2>> asyncMapRight<Y2>(
    Future<Either<X, Y2>> Function(Y right) rightFunction,
  ) async =>
      switch (this) {
        Left(:final left) => Either.left(left),
        Right(:final right) => await rightFunction(right),
      };
}
