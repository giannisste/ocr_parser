import 'usecase.dart';

class AuthenticatedUsecase<T1, T2, E1, E2> implements Usecase<T1, E1> {
  AuthenticatedUsecase(
    this.usecase,
    this.getTokenUsecase,
    this.tokenKey,
    this.authenticatedBuilder,
    this.onGetTokenError,
    this.tokenErrorMapper,
  );

  final Usecase<T1, E1> usecase;
  final Usecase<T2, E2> getTokenUsecase;

  final E2 tokenKey;
  final E1 Function(E1, T2) authenticatedBuilder;
  final bool Function(T2) onGetTokenError;
  final T1 Function(T2) tokenErrorMapper;

  @override
  Future<T1> execute(E1 event) async {
    final tokenResponse = await getTokenUsecase.execute(tokenKey);
    if (onGetTokenError(tokenResponse)) {
      return tokenErrorMapper(tokenResponse);
    } else {
      final authenticatedFilter = authenticatedBuilder(event, tokenResponse);
      final response = await usecase.execute(authenticatedFilter);
      return response;
    }
  }
}
