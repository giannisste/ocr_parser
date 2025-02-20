import 'predicate.dart';

class ListAndPredicate<T> implements Predicate<List<T>> {
  const ListAndPredicate({required this.itemPredicate});

  final Predicate<T> itemPredicate;
  
  @override
  bool check(List<T> data) => data.every(itemPredicate.check);
}
