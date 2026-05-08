import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/repo/repo_start_tripe/repo.dart';

class TripRepositoryImpl implements TripRepository {
  final ApiService apiService;

  TripRepositoryImpl(this.apiService);

  @override
  Future<Either<Failur, String>> startTrip({required String tripId}) async {
    print("---------------- [🚀 START TRIP REQUEST] ----------------");
    print("🆔 Trip ID: $tripId");
    print("🔗 Endpoint: trips/start-trip/$tripId");

    try {
      final response = await apiService.get(
        needToken: true,
        endpoint: 'trips/start-trip/$tripId',
      );

      print("✅ [SUCCESS] Response Data: ${response.data}");

      String message = "Trip started successfully";

      if (response.data is Map<String, dynamic>) {
        message = response.data['message'] ?? message;
      }

      print("💬 Success Message: $message");
      print("---------------------------------------------------------");

      return right(message);
    } catch (e) {
      print("❌ [FAILURE] Error detected during startTrip");

      if (e is DioException) {
        final failure = ServierFailur.fromDioError(e);
        print("🚨 Dio Error Type: ${e.type}");
        print("🚨 Error Message: ${failure.errMassage}");
        print("🚨 Status Code: ${e.response?.statusCode}");
        print("🚨 Response Data: ${e.response?.data}");
        print("---------------------------------------------------------");
        return left(failure);
      }

      print("🚨 Unknown Error: ${e.toString()}");
      print("---------------------------------------------------------");
      return left(ServierFailur(e.toString(), 500));
    }
  }
}