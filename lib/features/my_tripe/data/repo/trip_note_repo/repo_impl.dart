
import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_servise.dart';

import 'package:drever_warr/core/service/failear.dart';

import 'package:drever_warr/features/my_tripe/data/repo/trip_note_repo/repo.dart';

class TripNoteRepositoryImpl implements TripNoteRepository {
  final ApiService apiService;

  TripNoteRepositoryImpl(this.apiService);

  @override
  Future<Either<Failur, String>> fetchTripNote({
    required String tripId,
  }) async {
    AppLogger.debug("---------------- [📝 GET TRIP NOTE REQUEST] ----------------");
    AppLogger.debug("🆔 Trip ID: $tripId");
    AppLogger.debug("🔗 Endpoint: trips/get-notes/$tripId");
    AppLogger.debug("🔑 Status: Sending GET Request...");

    try {
      final response = await apiService.get(
        endpoint: 'trips/get-notes/$tripId',
        needToken: true,
      );

      AppLogger.debug("✅ [SUCCESS] Server Responded Successfully");
      AppLogger.debug("📦 Response Body: ${response.data}");

      String note = "";

      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'];
        if (data is Map<String, dynamic>) {
          note = data['notes']?.toString() ?? "";
        } else {
          note = response.data['notes']?.toString() ?? "";
        }
      }

      AppLogger.debug("💬 Final Note: $note");
      AppLogger.debug("------------------------------------------------------------");

      return right(note);
    } catch (e) {
      AppLogger.debug("❌ [FAILURE] Error in fetchTripNote");

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