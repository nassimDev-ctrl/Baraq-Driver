import 'dart:developer';

import 'package:dartz/dartz.dart';
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
    print("---------------- [📝 GET TRIP NOTE REQUEST] ----------------");
    print("🆔 Trip ID: $tripId");
    print("🔗 Endpoint: trips/get-notes/$tripId");
    print("🔑 Status: Sending GET Request...");

    try {
      final response = await apiService.get(
        endpoint: 'trips/get-notes/$tripId',
        needToken: true,
      );

      print("✅ [SUCCESS] Server Responded Successfully");
      print("📦 Response Body: ${response.data}");

      String note = "";

      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'];
        if (data is Map<String, dynamic>) {
          note = data['notes']?.toString() ?? "";
        } else {
          note = response.data['notes']?.toString() ?? "";
        }
      }

      print("💬 Final Note: $note");
      print("------------------------------------------------------------");

      return right(note);
    } catch (e) {
      print("❌ [FAILURE] Error in fetchTripNote");

      if (e is DioException) {
        final failure = ServierFailur.fromDioError(e);
        print("🚨 Dio Error Type: ${e.type}");
        print("🚨 Status Code: ${e.response?.statusCode}");
        print("🚨 Error Data from Server: ${e.response?.data}");
        print("🚨 Failure Message: ${failure.errMassage}");
        print("------------------------------------------------------------");
        return left(failure);
      }

      print("🚨 Unexpected Error: ${e.toString()}");
      print("------------------------------------------------------------");
      return left(ServierFailur(e.toString(), 500));
    }
  }
}