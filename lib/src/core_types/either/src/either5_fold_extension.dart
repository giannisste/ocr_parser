import 'either5.dart';

extension Either5FoldExtension<X, Y, Z, W, Q> on Either5<X, Y, Z, W, Q> {
  S fold<S>(
    S Function(X first) firstFunction,
    S Function(Y second) secondFunction,
    S Function(Z third) thirdFunction,
    S Function(W third) fourthFunction,
    S Function(Q third) fifthFunction,
  ) =>
      switch (this) {
        First5(:final first) => firstFunction(first),
        Second5(:final second) => secondFunction(second),
        Third5(:final third) => thirdFunction(third),
        Fourth5(:final fourth) => fourthFunction(fourth),
        Fifth5(:final fifth) => fifthFunction(fifth),
      };

  Future<S> asyncFold<S>(
    Future<S> Function(X first) firstFunction,
    Future<S> Function(Y second) secondFunction,
    Future<S> Function(Z third) thirdFunction,
    Future<S> Function(W third) fourthFunction,
    Future<S> Function(Q third) fifthFunction,
  ) async =>
      switch (this) {
        First5(:final first) => await firstFunction(first),
        Second5(:final second) => await secondFunction(second),
        Third5(:final third) => await thirdFunction(third),
        Fourth5(:final fourth) => await fourthFunction(fourth),
        Fifth5(:final fifth) => await fifthFunction(fifth),
      };

  Either5<X2, Y, Z, W, Q> mapFirst<X2>(
    Either5<X2, Y, Z, W, Q> Function(X first) firstFunction,
  ) =>
      fold(firstFunction, Either5.second, Either5.third, Either5.fourth, Either5.fifth);

  Either5<X, Y2, Z, W, Q> mapSecond<Y2>(
    Either5<X, Y2, Z, W, Q> Function(Y second) secondFunction,
  ) =>
      fold(Either5.first, secondFunction, Either5.third, Either5.fourth, Either5.fifth);

  Either5<X, Y, Z2, W, Q> mapThird<Z2>(
    Either5<X, Y, Z2, W, Q> Function(Z third) thirdFunction,
  ) =>
      fold(Either5.first, Either5.second, thirdFunction, Either5.fourth, Either5.fifth);

  Either5<X, Y, Z, W2, Q> mapFourth<W2>(
    Either5<X, Y, Z, W2, Q> Function(W fourth) fourthFunction,
  ) =>
      fold(Either5.first, Either5.second, Either5.third, fourthFunction, Either5.fifth);

  Either5<X, Y, Z, W, Q2> mapFifth<Q2>(
    Either5<X, Y, Z, W, Q2> Function(Q fifth) fifthFunction,
  ) =>
      fold(Either5.first, Either5.second, Either5.third, Either5.fourth, fifthFunction);

  Either5<X2, Y2, Z2, W2, Q2> map<X2, Y2, Z2, W2, Q2>(
    X2 Function(X first) firstFunction,
    Y2 Function(Y second) secondFunction,
    Z2 Function(Z third) thirdFunction,
    W2 Function(W fourth) fourthFunction,
    Q2 Function(Q fifth) fifthFunction,
  ) =>
      fold(
        (first) => Either5.first(firstFunction(first)),
        (second) => Either5.second(secondFunction(second)),
        (third) => Either5.third(thirdFunction(third)),
        (fourth) => Either5.fourth(fourthFunction(fourth)),
        (fifth) => Either5.fifth(fifthFunction(fifth)),
      );
}
