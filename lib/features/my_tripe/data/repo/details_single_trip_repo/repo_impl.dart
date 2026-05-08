import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/model/model_finsh_trips.dart';
import 'package:drever_warr/features/my_tripe/data/model/single_finished_trip.dart';
import 'package:drever_warr/features/my_tripe/data/repo/details_single_trip_repo/repo.dart';

class SingleTripDetailsRepositoryImpl implements SingleTripDetailsRepository {
  final ApiService apiService;

  SingleTripDetailsRepositoryImpl(this.apiService);

  @override
  Future<Either<Failur, SingleFinishedTripModel>> getTripById({
    required String tripId,
  }) async {
    print("---------------- [🚕 GET TRIP DETAILS REQUEST] ----------------");
    print("🆔 Trip ID: $tripId");
    print("🔗 Endpoint: trips/get-trip/$tripId");
    print("🔑 Status: Sending GET Request...");

    try {
      final response = await apiService.get(
        endpoint: '/trips/get-trip/$tripId',
        needToken: true,
      );

      print("✅ [SUCCESS] Server Responded Successfully");
      print("📦 Response Body: ${response.data}");

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

      print("💬 Trip loaded successfully");
      print("single trip : $data");
      print("------------------------------------------------------------");

      return right(trip);
    } catch (e) {
      print("❌ [FAILURE] Error in getTripById");

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