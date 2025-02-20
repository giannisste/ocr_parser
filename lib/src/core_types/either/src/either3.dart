sealed class Either3<T1, T2, T3> {
  const Either3();

  factory Either3.first(T1 first) => First3._(first);
  factory Either3.second(T2 second) => Second3._(second);
  factory Either3.third(T3 third) => Third3._(third);

  bool get isFirst => this is First3<T1, T2, T3>;
  bool get isSecond => this is Second3<T1, T2, T3>;
  bool get isThird => this is Third3<T1, T2, T3>;
}

final class First3<T1, T2, T3> extends Either3<T1, T2, T3> {
  const First3._(this.first);
  final T1 first;
}

final class Second3<T1, T2, T3> extends Either3<T1, T2, T3> {
  const Second3._(this.second);
  final T2 second;
}

final class Third3<T1, T2, T3> extends Either3<T1, T2, T3> {
  const Third3._(this.third);
  final T3 third;
}
