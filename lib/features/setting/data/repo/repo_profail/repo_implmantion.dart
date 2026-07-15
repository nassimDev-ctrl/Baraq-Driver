import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_service.dart';

import 'package:drever_warr/core/service/failure.dart';

import 'package:drever_warr/features/setting/data/model/model_profail.dart';

import 'package:drever_warr/features/setting/data/repo/repo_profail/repo.dart';
 
class ImplementRepoProfile extends RepoProfile {
  final ApiService _apiService;

  ImplementRepoProfile({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failure, ProfileModel>> getProfile() async {
    AppLogger.error("--------------------------------------------------");
    AppLogger.debug("🚀 [START REQUEST] Endpoint: /drivers/get-profile");

    try {
      Response response = await _apiService.get(
        endpoint: "/drivers/get-profile",
        needToken: true,
      );

      
      AppLogger.debug("✅ [RESPONSE RECEIVED]");
      AppLogger.debug("📌 Status Code: ${response.statusCode}");
      AppLogger.debug("📄 Response Data: ${response.data}"); 

      if (response.data["success"] == true) {
        AppLogger.debug("✨ [PARSING DATA] Converting JSON to ProfileModel...");

        final profileModel = ProfileModel.fromJson(response.data);

       
        AppLogger.debug(
          "👤 User Name from Model: ${profileModel.data?.firstName} ${profileModel.data?.lastName}",
        );
        AppLogger.debug("--------------------------------------------------");

        return right(profileModel);
      } else {
        AppLogger.debug("⚠️ [SERVER ERROR] Success is false");
        AppLogger.error("📝 Error Message: ${response.data['message']}");
        return left(
          ServerFailure.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      AppLogger.debug("❌ [EXCEPTION CAUGHT]");
      if (e is DioException) {
        AppLogger.debug("🔌 Dio Error Type: ${e.type}");
        AppLogger.error("📥 Dio Error Response: ${e.response?.data}");
        AppLogger.error("🔢 Dio Status Code: ${e.response?.statusCode}");
        return left(ServerFailure.fromDioError(e));
      }

      AppLogger.error("🆘 Generic Error: ${e.toString()}");
      AppLogger.error("--------------------------------------------------");
      return left(
        ServerFailure('حدث خطأ أثناء جلب البيانات: ${e.toString()}', 500),
      );
    }
  }
}