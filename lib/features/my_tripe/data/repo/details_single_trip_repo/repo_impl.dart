import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_servise.dart';

import 'package:drever_warr/core/service/failear.dart';


import 'package:drever_warr/features/my_tripe/data/model/single_finished_trip.dart';

import 'package:drever_warr/features/my_tripe/data/repo/details_single_trip_repo/repo.dart';

class SingleTripDetailsRepositoryImpl implements SingleTripDetailsRepository {
  final ApiService apiService;

  SingleTripDetailsRepositoryImpl(this.apiService);

  @override
  Future<Either<Failur, SingleFinishedTripModel>> getTripById({
    required String tripId,
  }) async {
    AppLogger.debug("---------------- [🚕 GET TRIP DETAILS REQUEST] ----------------");
    AppLogger.debug("🆔 Trip ID: $tripId");
    AppLogger.debug("🔗 Endpoint: trips/get-trip/$tripId");
    AppLogger.debug("🔑 Status: Sending GET Request...");

    try {
      final response = await apiService.get(
        endpoint: '/trips/get-trip/$tripId',
        needToken: true,
      );

      AppLogger.debug("✅ [SUCCESS] Server Responded Successfully");
      AppLogger.debug("📦 Response Body: ${response.data}");

      dynamic data = response.data;

      if (data is Map<String, dynamic>) {
        data = data['data'] ?? data['trip'] ?? data;
      }

      if (data is! Map<String, dynamic>) {
        throw Exception("Invalid response format for trip details");
      }

      final trip = SingleFinishedTripModel.fromJson(
        Map<String, dynamic>.from(data),
      );

      AppLogger.debug("💬 Trip loaded successfully");
      AppLogger.debug("single trip : $data");
      AppLogger.debug("------------------------------------------------------------");

      return right(trip);
    } catch (e) {
      AppLogger.debug("❌ [FAILURE] Error in getTripById");

      if (e is DioException) {
        final failure = ServierFailur.fromDioError(e);
        AppLogger.error("🚨 Dio Error Type: ${e.type}");
        AppLogger.error("🚨 Status Code: ${e.response?.statusCode}");
        AppLogger.debug("🚨 Error Data from Server: ${e.response?.data}");
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