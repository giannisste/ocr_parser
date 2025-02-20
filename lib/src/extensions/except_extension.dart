
import '../core_types/either/either.dart';

extension ExceptExtension0<R> on R Function() {
  S foldExcept<Exc extends Object, S>({
    required S Function(R) onData,
    required S Function(Exc) onException,
  }) {
    try {
      return onData(this());
    } on Exc catch (error) {
      return onException(error);
    }
  }
}

extension AsyncExceptExtension0<R> on Future<R> Function() {
  Future<S> asyncExcept<Exc extends Object, S>({
    required S Function(R) onData,
    required S Function(Exc) onException,
  }) async {
    try {
      return onData(await this());
    } on Exc catch (error) {
      return Future.value(onException(error));
    }
  }

  Future<S> asyncDualExcept<Exc extends Object, Exc2 extends Object, S>({
    required S Function(R) onData,
    required S Function(Either<Exc, Exc2>) onException,
  }) async {
    try {
      return onData(await this());
    } on Exc catch (error) {
      return Future.value(onException(Either.left(error)));
    } on Exc2 catch (error2) {
      return Future.value(onException(Either.right(error2)));
    }
  }
}

extension ExceptExtension<T, R> on R Function(T) {
  S foldExcept<Exc extends Object, S>(
    T data, {
    required S Function(R) onData,
    required S Function(Exc) onException,
  }) {
    try {
      return onData(this(data));
    } on Exc catch (error) {
      return onException(error);
    }
  }
}

extension AsyncExceptExtension<T, R> on Future<R> Function(T) {
  Future<S> asyncExcept<Exc extends Object, S>(
    T data, {
    required S Function(R) onData,
    required S Function(Exc) onException,
  }) async {
    try {
      return onData(await this(data));
    } on Exc catch (error) {
      return Future.value(onException(error));
    }
  }
}

extension ExceptExtension2<T1, T2, R> on R Function(T1, T2) {
  S except<Exc extends Object, S>(
    (T1, T2) data, {
    required S Function(R) onData,
    required S Function(Exc) onException,
  }) {
    try {
      return onData(this(data.$1, data.$2));
    } on Exc catch (error) {
      return onException(error);
    }
  }
}

extension AsyncExceptExtension2<T1, T2, R> on Future<R> Function(T1, T2) {
  Future<S> asyncExcept<Exc extends Object, S>(
    (T1, T2) data, {
    required S Function(R) onData,
    required S Function(Exc) onException,
  }) async {
    try {
      return onData(await this(data.$1, data.$2));
    } on Exc catch (error) {
      return Future.value(onException(error));
    }
  }
}
