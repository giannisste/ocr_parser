sealed class Either4<T1, T2, T3, T4> {
  const Either4();

  factory Either4.first(T1 first) => First4._(first);
  factory Either4.second(T2 second) => Second4._(second);
  factory Either4.third(T3 third) => Third4._(third);
  factory Either4.fourth(T4 fourth) => Fourth4._(fourth);

  bool get isFirst => this is First4<T1, T2, T3 ,T4>;
  bool get isSecond => this is Second4<T1, T2, T3, T4>;
  bool get isThird => this is Third4<T1, T2, T3, T4>;
  bool get isFourth => this is Fourth4<T1, T2, T3, T4>;
}

final class First4<T1, T2, T3, T4> extends Either4<T1, T2, T3, T4> {
  const First4._(this.first);
  final T1 first;
}

final class Second4<T1, T2, T3, T4> extends Either4<T1, T2, T3, T4> {
  const Second4._(this.second);
  final T2 second;
}

final class Third4<T1, T2, T3, T4> extends Either4<T1, T2, T3, T4> {
  const Third4._(this.third);
  final T3 third;
}

final class Fourth4<T1, T2, T3, T4> extends Either4<T1, T2, T3, T4> {
  const Fourth4._(this.fourth);
  final T4 fourth;
}
