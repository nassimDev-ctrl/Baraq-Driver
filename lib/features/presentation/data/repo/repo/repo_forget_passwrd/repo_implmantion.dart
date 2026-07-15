import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_service.dart';

import 'package:drever_warr/core/service/failure.dart';

import 'package:drever_warr/features/presentation/data/repo/repo/repo_forget_passwrd/repo.dart';
 
 
 

class ConfirmPasswordRepoImpl extends ConfirmPasswordRepo {
  final ApiService _apiService;
  ConfirmPasswordRepoImpl(this._apiService);

  @override
  Future<Either<Failure, dynamic>> confirmPassword({
    required String mobilphone,
    required String password,
  }) async {
    final Map<String, dynamic> body = {
      "newPassword": password,
      "mobilePhone": mobilphone,
    };

   
    AppLogger.debug("🚀 [API START]: Confirm Password");
    AppLogger.debug("🔗 [URL]: https://api.waslninow.com/auth-users/reset-password");
    AppLogger.debug("📦 [Payload Body]: $body");

    try {
      Response response = await _apiService.put(
        endPoint: "auth-users/reset-password",
        data: body,
        isfromdata: false,
        
      );

     
      AppLogger.debug("✅ [API SUCCESS]");
      AppLogger.debug("🔢 [Status Code]: ${response.statusCode}");
      AppLogger.debug("📄 [Response Data]: ${response.data}");

      if (response.data["success"] == true) {
        return right(response.data);
      } else {
        AppLogger.debug("⚠️ [API LOGIC ERROR]: Success field is false");
        return left(
          ServerFailure.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      
      AppLogger.debug("❌ [API EXCEPTION]");

      if (e is DioException) {
        AppLogger.debug("🛑 [Dio Error Type]: ${e.type}");
        AppLogger.error("🔢 [Error Status Code]: ${e.response?.statusCode}");
        AppLogger.error("📄 [Error Response Body]: ${e.response?.data}");
        AppLogger.error("📧 [Error Message]: ${e.message}");
        return left(ServerFailure.fromDioError(e));
      } else {
        AppLogger.error("🛠️ [General Exception]: ${e.toString()}");
        return left(ServerFailure('حدث خطأ غير متوقع: ${e.toString()}', 500));
      }
    }
  }
}