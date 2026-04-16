import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
 

import 'repo.dart';

class ChangePasswordRepoImpl extends ChangePasswordRepo {
  final ApiService _apiService;

  ChangePasswordRepoImpl(this._apiService);

  @override
  Future<Either<Failur, String>> changePassword({
    required String newPassword,
  }) async {
    try {
     
      log("-----------------------------------------");
      log("🚀 [API START]: Change Password Request");
      log("🔗 [Endpoint]: /auth-users/change-password");
      log("📦 [Payload Body]: {'newPassword': '$newPassword'}");
      log("-----------------------------------------");

      Response response = await _apiService.put(
        endPoint: "/auth-users/change-password",
        data: {"newPassword": newPassword},
        isfromdata: false,
      );

     
      log("✅ [API SUCCESS]");
      log("🔢 [Status Code]: ${response.statusCode}");
      log("📄 [Full Response Data]: ${response.data}");

      if (response.data["success"] == true) {
        log("🎯 [Result]: Success Field is True");
        return right(response.data["message"] ?? "تم التغيير بنجاح");
      } else {
        
        log("⚠️ [SERVER LOGIC ERROR]");
        log("📄 [Message from Server]: ${response.data["message"]}");
        return left(
          ServierFailur(response.data["message"] ?? "فشل التغيير", 400),
        );
      }
    } catch (e) {
      log("❌ [API EXCEPTION OCCURRED]");

      if (e is DioException) {
      
        log("🛑 [Dio Error Type]: ${e.type}");
        log("🔢 [Error Status Code]: ${e.response?.statusCode}");
        log("📄 [Error Response Body]: ${e.response?.data}");
        log("📧 [Dio Message]: ${e.message}");

      
        if (e.response?.statusCode == 401) {
          log("🚨 [CRITICAL]: Token is Invalid or Expired!");
        }

        return left(ServierFailur.fromDioError(e));
      }

     
      log("🚨 [UNKNOWN ERROR]: ${e.toString()}");
      return left(ServierFailur("حدث خطأ غير متوقع", 500));
    } finally {
      log("-----------------------------------------");
      log("🏁 [API END]: Change Password Process Finished");
      log("-----------------------------------------");
    }
  }
}
