import '../core_types/either/either.dart';
import 'compose_extension.dart';

extension UpdateExtension<X, Y> on Y Function(X Function(X)) {
  Y update(X value) => this((_) => value);
}

extension DistributeFunctionExtension<A, B1, B2, R> on R Function(Either<B1, B2>) {
  (R Function(B1), R Function(B2)) distribute() => (compose(Either.left), compose(Either.right));
}

extension DistributeFunctionExtension3<A, B1, B2, B3, R> on R Function(Either3<B1, B2, B3>) {
  (R Function(B1), R Function(B2), R Function(B3)) distribute() =>
      (compose(Either3.first), compose(Either3.second), compose(Either3.third));
}

extension DistributeExtension<A, B1, B2> on (A, Either<B1, B2>) {
  Either<(A, B1), (A, B2)> distribute() => $2.map((left) => ($1, left), (right) => ($1, right));
}
