import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/model/model_finsh_trips.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/repo/current_trip_repo/repo.dart';

import '../../cubit/model/accsept_model.dart';

class GetStartedTripsRepositoryImpl implements GetStartedTripsRepository {
  final ApiService apiService;

  GetStartedTripsRepositoryImpl(this.apiService);

  @override
  Future<Either<Failur, List<ActiveTripModel>>> getStartedTrips() async {
    print("---------------- [🚕 GET STARTED TRIPS REQUEST] ----------------");
    print("🔗 Endpoint: trips/get-started-trips");
    print("🔑 Status: Sending GET Request...");

    try {
      final response = await apiService.get(
        endpoint: 'trips/get-started-trips',
        needToken: true,
      );

      print("✅ [SUCCESS] Server Responded Successfully");
      print("📦 Response Body: ${response.data}");

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

      print("💬 Loaded trips count: ${trips.length}");
      print("------------------------------------------------------------");

      return right(trips);
    } catch (e) {
      print("❌ [FAILURE] Error in getStartedTrips");

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