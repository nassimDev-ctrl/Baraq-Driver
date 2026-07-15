import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_servise.dart';

import 'package:drever_warr/core/service/failear.dart';

import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/repo/repo_start_tripe/repo.dart';

class TripRepositoryImpl implements TripRepository {
  final ApiService apiService;

  TripRepositoryImpl(this.apiService);

  @override
  Future<Either<Failur, String>> startTrip({required String tripId}) async {
    AppLogger.error("---------------- [🚀 START TRIP REQUEST] ----------------");
    AppLogger.debug("🆔 Trip ID: $tripId");
    AppLogger.debug("🔗 Endpoint: trips/start-trip/$tripId");

    try {
      final response = await apiService.get(
        needToken: true,
        endpoint: 'trips/start-trip/$tripId',
      );

      AppLogger.debug("✅ [SUCCESS] Response Data: ${response.data}");

      String message = "Trip started successfully";

      if (response.data is Map<String, dynamic>) {
        message = response.data['message'] ?? message;
      }

      AppLogger.debug("💬 Success Message: $message");
      AppLogger.debug("---------------------------------------------------------");

      return right(message);
    } catch (e) {
      AppLogger.debug("❌ [FAILURE] Error detected during startTrip");

      if (e is DioException) {
        final failure = ServierFailur.fromDioError(e);
        AppLogger.error("🚨 Dio Error Type: ${e.type}");
        AppLogger.error("🚨 Error Message: ${failure.errMassage}");
        AppLogger.error("🚨 Status Code: ${e.response?.statusCode}");
        AppLogger.debug("🚨 Response Data: ${e.response?.data}");
        AppLogger.debug("---------------------------------------------------------");
        return left(failure);
      }

      AppLogger.error("🚨 Unknown Error: ${e.toString()}");
      AppLogger.error("---------------------------------------------------------");
      return left(ServierFailur(e.toString(), 500));
    }
  }
}