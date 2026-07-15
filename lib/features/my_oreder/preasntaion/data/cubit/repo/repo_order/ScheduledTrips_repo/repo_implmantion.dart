import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_servise.dart';

import 'package:drever_warr/core/service/failear.dart';

import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/model/scheduled_trips.dart';

import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/repo/repo_order/ScheduledTrips_repo/repo.dart';

class RepoScheduledTripsImpl extends RepoScheduledTrips {
  final ApiService _apiService;

  RepoScheduledTripsImpl(this._apiService);

  @override
  Future<Either<Failur, List<ScheduledTripModel>>> fetchScheduledTrips() async {
    try {
      AppLogger.debug("---------------- [START SCHEDULED REQUEST] ----------------");
      AppLogger.debug("🚀 Endpoint: /trips/get-scheduled-trips");

      var response = await _apiService.get(
        endpoint: "/trips/get-scheduled-trips",
        needToken: true,
      );

      AppLogger.debug("📡 Status Code: ${response.statusCode}");
      AppLogger.debug("📥 Raw Scheduled Data: ${response.data}");

      if (response.data["success"] == true) {
        List<dynamic> items = response.data["data"];
        AppLogger.debug("🔢 Number of scheduled trips found: ${items.length}");

       
        List<ScheduledTripModel> trips = items.map((e) {
          try {
            return ScheduledTripModel.fromJson(e);
          } catch (modelError) {
            AppLogger.error("⚠️ Error parsing individual scheduled trip: $modelError");
            AppLogger.error("📄 Problematic JSON Item: $e");
            rethrow; 
          }
        }).toList();

        AppLogger.debug("✅ Parsing Completed. List size: ${trips.length}");
        if (trips.isNotEmpty) {
          AppLogger.debug(
            "🔍 Sample Scheduled Trip (First): ID: ${trips.first.id}, Date: ${trips.first.scheduledDate}",
          );
        }

        return right(trips);
      } else {
        AppLogger.debug("❌ Server Logic Error (Success is False): ${response.data}");
        return left(
          ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      AppLogger.debug("---------------- [SCHEDULED REQUEST FAILED] ----------------");
      if (e is DioException) {
        AppLogger.error("🚩 DioError Type: ${e.type}");
        AppLogger.error("🚩 DioError Response: ${e.response?.data}");
        AppLogger.error("🚩 Request URL: ${e.requestOptions.uri}");
        return left(ServierFailur.fromDioError(e));
      }
      AppLogger.error("🚩 General Error: ${e.toString()}");
      return left(ServierFailur(e.toString(), 500));
    } finally {
      AppLogger.error("----------------- [END SCHEDULED REQUEST] -----------------");
    }
  }
}