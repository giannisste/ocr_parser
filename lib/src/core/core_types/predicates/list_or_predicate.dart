import 'predicate.dart';

class ListOrPredicate<T> implements Predicate<List<T>> {
  const ListOrPredicate({required this.itemPredicate});

  final Predicate<T> itemPredicate;
  
  @override
  bool check(List<T> data) => data.any(itemPredicate.check);
}
