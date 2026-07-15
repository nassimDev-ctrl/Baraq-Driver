import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/cash/preferences_service.dart';

import 'package:drever_warr/core/service/api_service.dart';

import 'package:drever_warr/core/service/failure.dart';

import 'package:drever_warr/features/presentation/data/repo/repo.dart';
// استيراد الـ CacheManager (تأكد من صحة المسار)
 
class ImplementRepoRegister extends RepoRegister {
  final ApiService _apiService;

  ImplementRepoRegister({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<Either<Failure, dynamic>> register({
    required Map<String, dynamic> userData,
  }) async {
    AppLogger.debug("🚀 [POST Request] Endpoint: /drivers/register");
    AppLogger.debug("📦 [Request Data]: $userData");

    try {
      Response response = await _apiService.postdata(
        "/drivers/register",
        data: userData,
        needToken: false,
        isfromdata: false,
      );

      AppLogger.debug("✅ [Response Received] Status Code: ${response.statusCode}");
      AppLogger.debug("📄 [Response Data]: ${response.data}");

      if (response.data["success"] == true) {
       
        final String? token = response.data['data']?['token'] ?? response.data['token'];
        
        if (token != null) {
          await CacheManager.saveData("token", token);
          AppLogger.debug("token : $token");
          AppLogger.debug("💾 [TOKEN SAVED]: Token has been stored in CacheManager.");
        } else {
          AppLogger.debug("⚠️ [TOKEN WARNING]: Success was true but no token found in response!");
        }
       

        AppLogger.debug("🎉 [Register Success]");
        return right(response.data);
      } else {
        AppLogger.debug("⚠️ [Logic Error from Server]: ${response.data}");
        return left(
          ServerFailure.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      AppLogger.debug("❌ [Exception Caught in Repo]: $e");

      if (e is DioException) {
        AppLogger.debug("🔴 [Dio Error Type]: ${e.type}");
        AppLogger.error("🔴 [Dio Error Response]: ${e.response?.data}");
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure('حدث خطأ أثناء التسجيل', 500));
    }
  }
}