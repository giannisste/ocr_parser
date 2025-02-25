import 'either4.dart';

extension Either4FoldExtension<X, Y, Z, W> on Either4<X, Y, Z, W> {
  S fold<S>(
    S Function(X first) firstFunction,
    S Function(Y second) secondFunction,
    S Function(Z third) thirdFunction,
    S Function(W third) fourthFunction,
  ) =>
      switch (this) {
        First4(:final first) => firstFunction(first),
        Second4(:final second) => secondFunction(second),
        Third4(:final third) => thirdFunction(third),
        Fourth4(:final fourth) => fourthFunction(fourth),
      };

  Future<S> asyncFold<S>(
    Future<S> Function(X first) firstFunction,
    Future<S> Function(Y second) secondFunction,
    Future<S> Function(Z third) thirdFunction,
    Future<S> Function(W third) fourthFunction,
  ) async =>
      switch (this) {
        First4(:final first) => await firstFunction(first),
        Second4(:final second) => await secondFunction(second),
        Third4(:final third) => await thirdFunction(third),
        Fourth4(:final fourth) => await fourthFunction(fourth),
      };

  Either4<X2, Y, Z, W> mapFirst<X2>(
    Either4<X2, Y, Z, W> Function(X first) firstFunction,
  ) =>
      fold(firstFunction, Either4.second, Either4.third, Either4.fourth);

  Either4<X, Y2, Z, W> mapSecond<Y2>(
    Either4<X, Y2, Z, W> Function(Y second) secondFunction,
  ) =>
      fold(Either4.first, secondFunction, Either4.third, Either4.fourth);

  Either4<X, Y, Z2, W> mapThird<Z2>(
    Either4<X, Y, Z2, W> Function(Z third) thirdFunction,
  ) =>
      fold(Either4.first, Either4.second, thirdFunction, Either4.fourth);

  Either4<X, Y, Z, W2> mapFourth<W2>(
    Either4<X, Y, Z, W2> Function(W third) fourthFunction,
  ) =>
      fold(Either4.first, Either4.second, Either4.third, fourthFunction);

  Either4<X2, Y2, Z2, W2> map<X2, Y2, Z2, W2>(
    X2 Function(X first) firstFunction,
    Y2 Function(Y second) secondFunction,
    Z2 Function(Z third) thirdFunction,
    W2 Function(W fourth) fourthFunction,
  ) =>
      fold(
        (first) => Either4.first(firstFunction(first)),
        (second) => Either4.second(secondFunction(second)),
        (third) => Either4.third(thirdFunction(third)),
        (fourth) => Either4.fourth(fourthFunction(fourth)),
      );
}
