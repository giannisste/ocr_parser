import 'either.dart';

extension DistributeLeftExtension<A1, A2, B> on (Either<A1, A2>, B) {
  Either<(A1, B), (A2, B)> get distribute => $1.map(
        (left) => (left, $2),
        (right) => (right, $2),
      );
}

extension DistributeRightExtension<A, B1, B2> on (A, Either<B1, B2>) {
  Either<(A, B1), (A, B2)> get distribute => $2.map(
        (left) => ($1, left),
        (right) => ($1, right),
      );
}
