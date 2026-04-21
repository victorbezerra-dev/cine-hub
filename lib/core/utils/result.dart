sealed class Result<T> {}

class Success<T> extends Result<T> {
  final T data;
  Success(this.data);
}

class CachedFallbackSuccess<T> extends Success<T> {
  final String? message;

  CachedFallbackSuccess(super.data, {this.message});
}

class Error<T> extends Result<T> {
  final Exception exception;
  Error(this.exception);
}
