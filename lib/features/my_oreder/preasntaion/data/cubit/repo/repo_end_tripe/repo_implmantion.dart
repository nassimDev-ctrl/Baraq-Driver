import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/repo/repo_end_tripe/repo.dart';

class EndTripRepositoryImpl implements EndTripRepository {
  final ApiService apiService;

  EndTripRepositoryImpl(this.apiService);

  @override
  Future<Either<Failur, String>> completeTrip({required String tripId}) async {
    print("---------------- [🏁 COMPLETE TRIP REQUEST] ----------------");
    print("🆔 Trip ID: $tripId");
    print("🔗 Endpoint: trips/complete-trip/$tripId");
    print("🔑 Status: Sending GET Request...");

    try {
      final response = await apiService.get(
        endpoint: 'trips/complete-trip/$tripId',
        needToken: true,
      );

      print("✅ [SUCCESS] Server Responded Successfully");
      print("📦 Response Body: $response");

      String message = response['message'] ?? "Trip completed successfully";
      print("💬 Final Message: $message");
      print("------------------------------------------------------------");

      return right(message);
    } catch (e) {
      print("❌ [FAILURE] Error in completeTrip");

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
