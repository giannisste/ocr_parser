import 'either3.dart';

extension Either3FoldExtension<X, Y, Z> on Either3<X, Y, Z> {
  S fold<S>(
    S Function(X first) firstFunction,
    S Function(Y second) secondFunction,
    S Function(Z third) thirdFunction,
  ) =>
      switch (this) {
        First3(:final first) => firstFunction(first),
        Second3(:final second) => secondFunction(second),
        Third3(:final third) => thirdFunction(third),
      };

  Future<S> asyncFold<S>(
    Future<S> Function(X first) firstFunction,
    Future<S> Function(Y second) secondFunction,
    Future<S> Function(Z third) thirdFunction,
  ) async =>
      switch (this) {
        First3(:final first) => await firstFunction(first),
        Second3(:final second) => await secondFunction(second),
        Third3(:final third) => await thirdFunction(third),
      };

  Either3<X2, Y, Z> mapFirst<X2>(
    Either3<X2, Y, Z> Function(X first) firstFunction,
  ) =>
      fold(firstFunction, Either3.second, Either3.third);

  Either3<X, Y2, Z> mapSecond<Y2>(
    Either3<X, Y2, Z> Function(Y second) secondFunction,
  ) =>
      fold(Either3.first, secondFunction, Either3.third);

  Either3<X, Y, Z2> mapThird<Z2>(
    Either3<X, Y, Z2> Function(Z third) thirdFunction,
  ) =>
      fold(Either3.first, Either3.second, thirdFunction);

  Either3<X2, Y2, Z2> map<X2, Y2, Z2>(
    X2 Function(X first) firstFunction,
    Y2 Function(Y second) secondFunction,
    Z2 Function(Z third) thirdFunction,
  ) =>
      fold(
        (first) => Either3.first(firstFunction(first)),
        (second) => Either3.second(secondFunction(second)),
        (third) => Either3.third(thirdFunction(third)),
      );
}
