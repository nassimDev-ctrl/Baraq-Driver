import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_service.dart';

import 'package:drever_warr/core/service/failure.dart';

import 'package:drever_warr/features/home/presentation/data/cubit/model/model_finsh_trips.dart';

import 'package:drever_warr/features/home/presentation/data/cubit/repo/finsh_trips_repo/repo.dart';


class GetFinishedTripsRepoImpl implements GetFinishedTripsRepo {
  final ApiService apiService;
  GetFinishedTripsRepoImpl(this.apiService);

  @override
  @override
  Future<Either<Failure, List<FinishedTripModel>>> getFinishedTrips() async {
    try {
      AppLogger.error("🌐 [START GET REQUEST] Endpoint: trips/get-finished-trips");

      var response = await apiService.get(
        endpoint: 'trips/get-finished-trips',
        needToken: true,
      );

      AppLogger.debug("📡 [SERVER RESPONSE STATUS]: ${response.statusCode}");
      AppLogger.debug("📦 [SERVER RESPONSE DATA]: ${response.data}");

     
      if (response.data['data'] is List) {
        List<dynamic> rawList = response.data['data'];  
        List<FinishedTripModel> trips = rawList
            .map((item) => FinishedTripModel.fromJson(item))
            .toList();

        AppLogger.debug("✅ [SUCCESS]: Parsed ${trips.length} trips.");
        return right(trips);
      } else {
        AppLogger.debug("⚠️ [WARNING]: 'data' key is missing or not a List.");
        return left(ServerFailure("لا يوجد بيانات صحيحة من السيرفر", 500));
      }
    } catch (e) {
      AppLogger.debug("❌ [GET FINISHED TRIPS ERROR]: ${e.toString()}");
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(
        ServerFailure('حدث خطأ في معالجة البيانات: ${e.toString()}', 500),
      );
    }
  }
}