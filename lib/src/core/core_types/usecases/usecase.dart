abstract interface class Usecase<T, E> {
  Future<T> execute(E event);
}
