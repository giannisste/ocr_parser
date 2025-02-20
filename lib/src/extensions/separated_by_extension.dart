extension SeparatedIterableExtension<T> on Iterable<T> {
  Iterable<T> switchSeparatedBy(T separator) {
    return switch (length) {
      <= 1 => this,
      _ => map((e) => [e, separator]).expand((element) => element)
    };
  }
}

extension SeparatedIterableYieldExtension<T> on Iterable<T> {
  Iterable<T> separatedBy(T separator) {
    return expand((item) sync* {
      yield separator;
      yield item;
    }).skip(1);
  }
}
