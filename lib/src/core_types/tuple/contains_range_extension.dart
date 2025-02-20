extension ContainsRangeExtension on (int, int) {
  bool contains(int number) => number >= this.$1 && number <= this.$2;
}
