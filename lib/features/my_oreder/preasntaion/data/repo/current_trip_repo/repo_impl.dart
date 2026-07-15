
import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_servise.dart';

import 'package:drever_warr/core/service/failear.dart';


import 'package:drever_warr/features/my_oreder/preasntaion/data/repo/current_trip_repo/repo.dart';

import '../../cubit/model/accsept_model.dart';

class GetStartedTripsRepositoryImpl implements GetStartedTripsRepository {
  final ApiService apiService;

  GetStartedTripsRepositoryImpl(this.apiService);

  @override
  Future<Either<Failur, List<ActiveTripModel>>> getStartedTrips() async {
    AppLogger.error("---------------- [🚕 GET STARTED TRIPS REQUEST] ----------------");
    AppLogger.debug("🔗 Endpoint: trips/get-started-trips");
    AppLogger.debug("🔑 Status: Sending GET Request...");

    try {
      final response = await apiService.get(
        endpoint: 'trips/get-started-trips',
        needToken: true,
      );

      AppLogger.debug("✅ [SUCCESS] Server Responded Successfully");
      AppLogger.debug("📦 Response Body: ${response.data}");

      dynamic data = response.data;

      if (data is Map<String, dynamic>) {
        data = data['data'] ?? [];
      }

      if (data is! List) {
        throw Exception("Invalid response format for started trips");
      }

      final trips = data
          .where((item) => item is Map<String, dynamic> || item is Map)
          .map((item) => ActiveTripModel.fromJson(
        Map<String, dynamic>.from(item as Map),
      ))
          .toList();

      AppLogger.debug("💬 Loaded trips count: ${trips.length}");
      AppLogger.debug("------------------------------------------------------------");

      return right(trips);
    } catch (e) {
      AppLogger.debug("❌ [FAILURE] Error in getStartedTrips");

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