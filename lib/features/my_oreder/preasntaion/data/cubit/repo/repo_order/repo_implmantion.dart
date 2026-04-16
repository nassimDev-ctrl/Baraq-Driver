import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/model/order_model.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/repo/repo_order/repo.dart';

class RepoSearchingTripsImpl extends RepoSearchingTrips {
  final ApiService _apiService;

  RepoSearchingTripsImpl(this._apiService);

  @override
  Future<Either<Failur, List<TripModel>>> fetchSearchingTrips() async {
    try {
      print("---------------- [START REQUEST] ----------------");
      print("🚀 Endpoint: /trips/get-searching-trips");

      var response = await _apiService.get(
        endpoint: "/trips/get-searching-trips",
        needToken: true,
      );

      print("📡 Status Code: ${response.statusCode}");
      print("📥 Raw Data: ${response.data}");

      if (response.data["success"] == true) {
        List<dynamic> items = response.data["data"];
        print("🔢 Number of trips found: ${items.length}");

        // تحويل قائمة الـ JSON إلى قائمة من الموديلات TripModel
        List<TripModel> trips = items.map((e) {
          try {
            return TripModel.fromJson(e);
          } catch (modelError) {
            print("⚠️ Error parsing individual trip: $modelError");
            print("📄 Problematic JSON: $e");
            rethrow;
          }
        }).toList();

        print("✅ Parsing Completed Successfully. List size: ${trips.length}");
        if (trips.isNotEmpty) {
          print(
            "🔍 Sample Trip (First Item): ID: ${trips.first.id}, Client: ${trips.first.clientName}",
          );
        }

        return right(trips);
      } else {
        print("❌ Server Logic Error: ${response.data}");
        return left(
          ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      print("---------------- [REQUEST FAILED] ----------------");
      if (e is DioException) {
        print("🚩 DioError Type: ${e.type}");
        print("🚩 DioError Response: ${e.response?.data}");
        print("🚩 Request Headers: ${e.requestOptions.headers}");
        return left(ServierFailur.fromDioError(e));
      }
      print("🚩 General Error: ${e.toString()}");
      return left(ServierFailur(e.toString(), 500));
    } finally {
      print("----------------- [END REQUEST] -----------------");
    }
  }
}
