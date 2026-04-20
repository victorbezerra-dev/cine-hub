import 'package:dio/dio.dart';
import 'general_failures.dart';

class DioFailure extends DioException implements Failure {
  DioFailure(DioException exception, {this.msg})
    : statusCode = exception.response?.statusCode ?? 400,
      super(
        requestOptions: exception.requestOptions,
        response: exception.response,
        type: exception.type,
        error: exception.error,
        stackTrace: exception.stackTrace,
        message:
            msg ?? exception.message ?? exception.response?.statusMessage ?? '',
      );

  final String? msg;
  final int? statusCode;

  @override
  String toString() {
    return message ?? 'DioFailure(statusCode: $statusCode, type: $type)';
  }
}

class NoInternetConection extends Failure {
  NoInternetConection({this.message});

  @override
  final String? message;
}

class RepositoryFailure extends Failure {
  RepositoryFailure({this.message});

  @override
  final String? message;
}
