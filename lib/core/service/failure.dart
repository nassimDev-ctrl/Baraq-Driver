import 'package:dio/dio.dart';

abstract class Failure {
  final String errMessage;
  final int statusCode;

  const Failure(this.errMessage, this.statusCode);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage, super.statusCode);

  factory ServerFailure.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure(
          'Connection timeout with the API server',
          dioException.response?.statusCode ?? 600,
        );
      case DioExceptionType.sendTimeout:
        return ServerFailure(
          'Send timeout with the API server',
          dioException.response?.statusCode ?? 601,
        );
      case DioExceptionType.receiveTimeout:
        return ServerFailure(
          'Receive timeout with the API server',
          dioException.response?.statusCode ?? 602,
        );
      case DioExceptionType.badCertificate:
        return ServerFailure(
          'Invalid certificate from the API server',
          dioException.response?.statusCode ?? 603,
        );
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
          dioException.response?.statusCode ?? 604,
          dioException.response?.data,
        );
      case DioExceptionType.cancel:
        return ServerFailure(
          'Request to the API server was cancelled',
          dioException.response?.statusCode ?? 605,
        );
      case DioExceptionType.connectionError:
        return ServerFailure(
          'Network error. Check your internet connection.',
          606,
        );
      case DioExceptionType.unknown:
        return ServerFailure(
          'Oops! Something went wrong. Please try again.',
          607,
        );
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    String errorMessage = 'حدث خطأ ما، حاول لاحقاً';

    if (response is Map) {
      errorMessage =
          response['msg']?['ar'] ??
          response['message'] ??
          response['error']?.toString() ??
          'Oops! Something went wrong.';
    } else if (response is String) {
      errorMessage = response;
    }

    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(errorMessage, statusCode);
    } else if (statusCode == 404) {
      return ServerFailure('Request not found (404)', statusCode);
    } else if (statusCode == 500) {
      return ServerFailure('Server error (500)', statusCode);
    } else {
      return ServerFailure(errorMessage, statusCode);
    }
  }
}
