import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/logging/app_logger.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/repo/logout_repo/repo.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  final ApiService apiService;

  LogoutRepositoryImpl(this.apiService);

  @override
  Future<Either<Failur, String>> logout() async {
    AppLogger.debug("---------------- [🚪 LOGOUT REQUEST] ----------------");
    AppLogger.debug("🔗 Endpoint: auth-users/logout");
    AppLogger.debug("🔑 Status: Sending GET Request...");

    try {
      final response = await apiService.get(
        endpoint: 'auth-users/logout',
        needToken: true,
      );

      AppLogger.debug("✅ [SUCCESS] Server Responded Successfully");
      AppLogger.debug("📦 Response Body: ${response.data}");

      String message = "Logged out successfully";

      if (response.data is Map<String, dynamic>) {
        message = response.data['message'] ?? message;
      }

      AppLogger.debug("💬 Final Message: $message");
      AppLogger.debug("------------------------------------------------------------");

      return right(message);
    } catch (e) {
      AppLogger.error("❌ [FAILURE] Error in logout");

      if (e is DioException) {
        final failure = ServierFailur.fromDioError(e);
        AppLogger.error("🚨 Dio Error Type: ${e.type}");
        AppLogger.error("🚨 Status Code: ${e.response?.statusCode}");
        AppLogger.error("🚨 Error Data from Server: ${e.response?.data}");
        AppLogger.error("🚨 Failure Message: ${failure.errMassage}");
        AppLogger.error("------------------------------------------------------------");
        return left(failure);
      }

      AppLogger.error("🚨 Unexpected Error: ${e.toString()}");
      AppLogger.error("------------------------------------------------------------");
      return left(ServierFailur(e.toString(), 500));
    }
  }
}
