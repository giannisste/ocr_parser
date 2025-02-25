import 'predicate.dart';

class ListContainsPredicate<T> implements Predicate<T> {
  const ListContainsPredicate({required this.allowedValues});

  final List<T> allowedValues;

  @override
  bool check(T data) {
    return allowedValues.contains(data);
  }
}
