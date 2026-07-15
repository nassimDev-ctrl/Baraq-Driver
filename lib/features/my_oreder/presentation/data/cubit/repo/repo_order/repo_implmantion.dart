import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_service.dart';

import 'package:drever_warr/core/service/failure.dart';

import 'package:drever_warr/features/my_oreder/presentation/data/cubit/model/order_model.dart';

import 'package:drever_warr/features/my_oreder/presentation/data/cubit/repo/repo_order/repo.dart';

class RepoSearchingTripsImpl extends RepoSearchingTrips {
  final ApiService _apiService;

  RepoSearchingTripsImpl(this._apiService);

  @override
  Future<Either<Failure, List<TripModel>>> fetchSearchingTrips() async {
    try {
      AppLogger.error("---------------- [START REQUEST] ----------------");
      AppLogger.debug("🚀 Endpoint: /trips/get-searching-trips");

      var response = await _apiService.get(
        endpoint: "/trips/get-searching-trips",
        needToken: true,
      );

      AppLogger.debug("📡 Status Code: ${response.statusCode}");
      AppLogger.debug("📥 Raw Data: ${response.data}");

      if (response.data["success"] == true) {
        List<dynamic> items = response.data["data"];
        AppLogger.debug("🔢 Number of trips found: ${items.length}");

        // تحويل قائمة الـ JSON إلى قائمة من الموديلات TripModel
        List<TripModel> trips = items.map((e) {
          try {
            return TripModel.fromJson(e);
          } catch (modelError) {
            AppLogger.error("⚠️ Error parsing individual trip: $modelError");
            AppLogger.error("📄 Problematic JSON: $e");
            rethrow;
          }
        }).toList();

        AppLogger.debug("✅ Parsing Completed Successfully. List size: ${trips.length}");
        if (trips.isNotEmpty) {
          AppLogger.debug(
            "🔍 Sample Trip (First Item): ID: ${trips.first.id}, Client: ${trips.first.clientName}",
          );
        }

        return right(trips);
      } else {
        AppLogger.debug("❌ Server Logic Error: ${response.data}");
        return left(
          ServerFailure.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      AppLogger.debug("---------------- [REQUEST FAILED] ----------------");
      if (e is DioException) {
        AppLogger.error("🚩 DioError Type: ${e.type}");
        AppLogger.error("🚩 DioError Response: ${e.response?.data}");
        AppLogger.error("🚩 Request Headers: ${e.requestOptions.headers}");
        return left(ServerFailure.fromDioError(e));
      }
      AppLogger.error("🚩 General Error: ${e.toString()}");
      return left(ServerFailure(e.toString(), 500));
    } finally {
      AppLogger.error("----------------- [END REQUEST] -----------------");
    }
  }
}