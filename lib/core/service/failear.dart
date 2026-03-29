// import 'package:best_price/core/utils/logger.dart';
import 'dart:developer';

import 'package:dio/dio.dart';

abstract class Failur {
  final String errMassage;
  final int statusCode;

  const Failur(this.errMassage, this.statusCode);
}

class ServierFailur extends Failur {
  ServierFailur(super.errMassage, super.statusCode);

  factory ServierFailur.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServierFailur(
          'Connection timeout with ApiServer',
          dioException.response?.statusCode ?? 600,
        );
      case DioExceptionType.sendTimeout:
        return ServierFailur(
          'Send timeout with ApiServer',
          dioException.response?.statusCode ?? 601,
        );
      case DioExceptionType.receiveTimeout:
        return ServierFailur(
          'Receive timeout with ApiServer',
          dioException.response?.statusCode ?? 602,
        );
      case DioExceptionType.badCertificate:
        return ServierFailur(
          'badCertificate with ApiServer',
          dioException.response?.statusCode ?? 603,
        );
      case DioExceptionType.badResponse:
        return ServierFailur.fromResponse(
          dioException.response?.statusCode ?? 604,
          dioException.response?.data,
        );
      case DioExceptionType.cancel:
        return ServierFailur(
          'Request to  ApiServer was cancel',
          dioException.response?.statusCode ?? 605,
        );
      case DioExceptionType.connectionError:
        return ServierFailur('network error, check your internet !', 606);
      case DioExceptionType.unknown:
        return ServierFailur('Ops There was an Error, Please try again!', 607);
    }
  }

  // factory ServierFailur.fromResponse(int statusCode, dynamic response) {
  //   // LoggerHelper.info('statusCode is $statusCode');

  //   // ignore: prefer_typing_uninitialized_variables
  //   var error;
  //   if (response is Map) {
  //     error = response[
  //         'data']; // ! here we should change the key after check from haydar baddour
  //   }

  //   if (statusCode == 401 || statusCode == 403 || statusCode == 422) {
  //     return ServierFailur(error, statusCode);
  //   } else if (statusCode == 404) {
  //     return ServierFailur(error ?? "User not found", statusCode);
  //   } else if (statusCode == 500) {
  //     return ServierFailur(
  //         'internal Server error, Please try later', statusCode);
  //   } else if (statusCode == 400) {
  //     return ServierFailur('Error in entered data', statusCode);
  //   } else {
  //     return ServierFailur(
  //         'Ops There was an Error, Please try again', statusCode);
  //   }
  // }
  factory ServierFailur.fromResponse(int statusCode, dynamic response) {
    // استخراج الرسالة بشكل ذكي مهما كان شكل الـ JSON
    String errorMessage = "حدث خطأ ما، حاول لاحقاً";

    if (response is Map) {
      // نتحقق من الحقول التي يرسلها سيرفرك (ar تعني العربي)
      errorMessage =
          response['msg']?['ar'] ??
          response['message'] ??
          response['error']?.toString() ??
          "Opps there was an error";
    } else if (response is String) {
      errorMessage = response;
    }

    // التوزيع حسب الـ Status Code
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServierFailur(errorMessage, statusCode);
    } else if (statusCode == 404) {
      return ServierFailur('Request not found (404)', statusCode);
    } else if (statusCode == 500) {
      return ServierFailur('Server error (500)', statusCode);
    } else {
      return ServierFailur(errorMessage, statusCode);
    }
  }
}

// class ErrorHandler {
//   static Failure handleError(dynamic e) {
//     if (e is DioException) {
//       LoggerHelper.error(' ########### Dio Exception #################');
//       LoggerHelper.error(e.message ?? "");
//       return ServerFailure.fromDioError(e);
//     }
//     return ServerFailure(e.toString(), 500);
//   }
// }
