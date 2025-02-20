sealed class Either5<T1, T2, T3, T4, T5> {
  const Either5();

  factory Either5.first(T1 first) => First5._(first);
  factory Either5.second(T2 second) => Second5._(second);
  factory Either5.third(T3 third) => Third5._(third);
  factory Either5.fourth(T4 fourth) => Fourth5._(fourth);
  factory Either5.fifth(T5 fifth) => Fifth5._(fifth);

  bool get isFirst => this is First5<T1, T2, T3, T4, T5>;
  bool get isSecond => this is Second5<T1, T2, T3, T4, T5>;
  bool get isThird => this is Third5<T1, T2, T3, T4, T5>;
  bool get isFourth => this is Fourth5<T1, T2, T3, T4, T5>;
  bool get isFifth => this is Fifth5<T1, T2, T3, T4, T5>;
}

final class First5<T1, T2, T3, T4, T5> extends Either5<T1, T2, T3, T4, T5> {
  const First5._(this.first);
  final T1 first;
}

final class Second5<T1, T2, T3, T4, T5> extends Either5<T1, T2, T3, T4, T5> {
  const Second5._(this.second);
  final T2 second;
}

final class Third5<T1, T2, T3, T4, T5> extends Either5<T1, T2, T3, T4, T5> {
  const Third5._(this.third);
  final T3 third;
}

final class Fourth5<T1, T2, T3, T4, T5> extends Either5<T1, T2, T3, T4, T5> {
  const Fourth5._(this.fourth);
  final T4 fourth;
}

final class Fifth5<T1, T2, T3, T4, T5> extends Either5<T1, T2, T3, T4, T5> {
  const Fifth5._(this.fifth);
  final T5 fifth;
}
