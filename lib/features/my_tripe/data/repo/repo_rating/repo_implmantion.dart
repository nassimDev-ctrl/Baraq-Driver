import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_servise.dart';

import 'package:drever_warr/core/service/failear.dart';
 
import 'repo.dart';

class AddRatingRepoImpl implements AddRatingRepo {
  final ApiService apiService;
  AddRatingRepoImpl(this.apiService);

  @override
  Future<Either<Failur, Map<String, dynamic>>> addRating({
    required String tripId,
    required String note,
    required int rating,
  }) async {
    try {
      AppLogger.debug(
        "🚀 [START POST REQUEST] Endpoint: trips/add-evalution-and-rating/$tripId",
      );
      AppLogger.debug("📝 [REQUEST BODY]: {note: $note, rating: $rating}");

      var response = await apiService.postdata(
        'trips/add-evalution-and-rating/$tripId',
        data: {"note": note, "rating": rating},
        isfromdata: false,
        needToken: true,
      );

      AppLogger.debug("📡 [SERVER RESPONSE STATUS]: ${response.statusCode}");
      AppLogger.debug("📦 [SERVER RESPONSE DATA]: ${response.data}");

      return right(response.data);
    } catch (e) {
      AppLogger.debug("❌ [ADD RATING ERROR]: ${e.toString()}");

      if (e is DioException) {
        AppLogger.error("⚠️ [DIO ERROR TYPE]: ${e.type}");
        AppLogger.error("⚠️ [DIO ERROR RESPONSE]: ${e.response?.data}");
        return left(ServierFailur.fromDioError(e));
      }

      return left(ServierFailur(e.toString(), 500));
    }
  }
}