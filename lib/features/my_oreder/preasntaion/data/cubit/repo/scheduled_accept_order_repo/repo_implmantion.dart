import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_servise.dart';

import 'package:drever_warr/core/service/failear.dart';

import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/repo/scheduled_accept_order_repo/repo.dart';

class ScheduledAcceptOrderRepoImpl extends ScheduledAcceptOrderRepo {
  final ApiService _apiService;

  ScheduledAcceptOrderRepoImpl(this._apiService);

  @override
  Future<Either<Failur, Map<String, dynamic>>> acceptScheduledTrip({
    required String tripId,
  }) async {
    try {
      AppLogger.debug("---------------- [🚀 START ACCEPT SCHEDULED TRIP REQUEST] ----------------");
      AppLogger.debug("📌 Trip ID: $tripId");
      AppLogger.debug("🔗 Endpoint: /trips/accept-scheduled-trip/$tripId");

      var response = await _apiService.get(
        endpoint: "/trips/accept-scheduled-trip/$tripId",
        needToken: true,
      );

      AppLogger.debug("📡 HTTP Status Code: ${response.statusCode}");
      AppLogger.debug("📥 Full Response Data: ${response.data}");

      if (response.data["success"] == true) {
        AppLogger.debug("✅ Success: Scheduled trip accepted successfully by server.");
        AppLogger.debug("---------------- [🏁 END REQUEST - SUCCESS] ----------------");
        return right(response.data);
      } else {
        AppLogger.debug("⚠️ Business Logic Error: 'success' is false in response.");
        AppLogger.error(
          "📄 Error Message: ${response.data['message'] ?? 'No message provided'}",
        );
        AppLogger.debug("---------------- [🏁 END REQUEST - LOGIC ERROR] ----------------");
        return left(
          ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      AppLogger.debug("---------------- [🚨 CRITICAL ERROR DURING REQUEST] ----------------");

      if (e is DioException) {
        AppLogger.debug("🚩 DioException Type: ${e.type}");
        AppLogger.debug("🚩 Dio Message: ${e.message}");
        AppLogger.debug("🚩 Server Response Data: ${e.response?.data}");
        AppLogger.debug("🚩 Status Code: ${e.response?.statusCode}");
        AppLogger.debug("---------------- [🏁 END REQUEST - DIO ERROR] ----------------");
        return left(ServierFailur.fromDioError(e));
      }

      AppLogger.error("🚩 General Error: ${e.toString()}");
      AppLogger.error("---------------- [🏁 END REQUEST - GENERAL ERROR] ----------------");
      return left(ServierFailur(e.toString(), 500));
    }
  }
}