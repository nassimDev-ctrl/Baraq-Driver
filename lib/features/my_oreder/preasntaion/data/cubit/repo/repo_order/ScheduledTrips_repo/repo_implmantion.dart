import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/model/ScheduledTrips.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/repo/repo_order/ScheduledTrips_repo/repo.dart';

class RepoScheduledTripsImpl extends RepoScheduledTrips {
  final ApiService _apiService;

  RepoScheduledTripsImpl(this._apiService);

  @override
  Future<Either<Failur, List<ScheduledTripModel>>> fetchScheduledTrips() async {
    try {
      print("---------------- [START SCHEDULED REQUEST] ----------------");
      print("🚀 Endpoint: /trips/get-scheduled-trips");

      var response = await _apiService.get(
        endpoint: "/trips/get-scheduled-trips",
        needToken: true,
      );

      print("📡 Status Code: ${response.statusCode}");
      print("📥 Raw Scheduled Data: ${response.data}");

      if (response.data["success"] == true) {
        List<dynamic> items = response.data["data"];
        print("🔢 Number of scheduled trips found: ${items.length}");

       
        List<ScheduledTripModel> trips = items.map((e) {
          try {
            return ScheduledTripModel.fromJson(e);
          } catch (modelError) {
            print("⚠️ Error parsing individual scheduled trip: $modelError");
            print("📄 Problematic JSON Item: $e");
            rethrow; 
          }
        }).toList();

        print("✅ Parsing Completed. List size: ${trips.length}");
        if (trips.isNotEmpty) {
          print(
            "🔍 Sample Scheduled Trip (First): ID: ${trips.first.id}, Date: ${trips.first.scheduledDate}",
          );
        }

        return right(trips);
      } else {
        print("❌ Server Logic Error (Success is False): ${response.data}");
        return left(
          ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      print("---------------- [SCHEDULED REQUEST FAILED] ----------------");
      if (e is DioException) {
        print("🚩 DioError Type: ${e.type}");
        print("🚩 DioError Response: ${e.response?.data}");
        print("🚩 Request URL: ${e.requestOptions.uri}");
        return left(ServierFailur.fromDioError(e));
      }
      print("🚩 General Error: ${e.toString()}");
      return left(ServierFailur(e.toString(), 500));
    } finally {
      print("----------------- [END SCHEDULED REQUEST] -----------------");
    }
  }
}
