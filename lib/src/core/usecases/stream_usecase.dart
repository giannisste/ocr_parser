abstract interface class StreamUsecase<T, E> {
  Stream<T> execute(E event);
}
