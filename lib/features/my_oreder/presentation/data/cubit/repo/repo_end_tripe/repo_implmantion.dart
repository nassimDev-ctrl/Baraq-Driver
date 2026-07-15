import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_service.dart';

import 'package:drever_warr/core/service/failure.dart';

import 'package:drever_warr/features/my_oreder/presentation/data/cubit/repo/repo_end_tripe/repo.dart';

class EndTripRepositoryImpl implements EndTripRepository {
  final ApiService apiService;

  EndTripRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, String>> completeTrip({required String tripId}) async {
    AppLogger.error("---------------- [🏁 COMPLETE TRIP REQUEST] ----------------");
    AppLogger.debug("🆔 Trip ID: $tripId");
    AppLogger.debug("🔗 Endpoint: trips/complete-trip/$tripId");
    AppLogger.debug("🔑 Status: Sending GET Request...");

    try {
      final response = await apiService.get(
        endpoint: '/trips/complete-trip/$tripId',
        needToken: true,
      );

      AppLogger.debug("✅ [SUCCESS] Server Responded Successfully");
      AppLogger.debug("📦 Response Body: ${response.data}");

      String message = "Trip completed successfully";

      if (response.data is Map<String, dynamic>) {
        message = response.data['message'] ?? message;
      }

      AppLogger.debug("💬 Final Message: $message");
      AppLogger.debug("------------------------------------------------------------");

      return right(message);
    } catch (e) {
      AppLogger.debug("❌ [FAILURE] Error in completeTrip");

      if (e is DioException) {
        final failure = ServerFailure.fromDioError(e);
        AppLogger.error("🚨 Dio Error Type: ${e.type}");
        AppLogger.error("🚨 Status Code: ${e.response?.statusCode}");
        AppLogger.debug("🚨 Error Data from Server: ${e.response?.data}");
        AppLogger.error("🚨 Failure Message: ${failure.errMessage}");
        AppLogger.error("------------------------------------------------------------");
        return left(failure);
      }

      AppLogger.error("🚨 Unexpected Error: ${e.toString()}");
      AppLogger.error("------------------------------------------------------------");
      return left(ServerFailure(e.toString(), 500));
    }
  }
}