import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/repo/scheduled_accept_order_repo/repo.dart';

class ScheduledAcceptOrderRepoImpl extends ScheduledAcceptOrderRepo {
  final ApiService _apiService;

  ScheduledAcceptOrderRepoImpl(this._apiService);

  @override
  Future<Either<Failur, Map<String, dynamic>>> acceptScheduledTrip({
    required String tripId,
  }) async {
    try {
      print("---------------- [🚀 START ACCEPT SCHEDULED TRIP REQUEST] ----------------");
      print("📌 Trip ID: $tripId");
      print("🔗 Endpoint: /trips/accept-scheduled-trip/$tripId");

      var response = await _apiService.get(
        endpoint: "/trips/accept-scheduled-trip/$tripId",
        needToken: true,
      );

      print("📡 HTTP Status Code: ${response.statusCode}");
      print("📥 Full Response Data: ${response.data}");

      if (response.data["success"] == true) {
        print("✅ Success: Scheduled trip accepted successfully by server.");
        print("---------------- [🏁 END REQUEST - SUCCESS] ----------------");
        return right(response.data);
      } else {
        print("⚠️ Business Logic Error: 'success' is false in response.");
        print(
          "📄 Error Message: ${response.data['message'] ?? 'No message provided'}",
        );
        print("---------------- [🏁 END REQUEST - LOGIC ERROR] ----------------");
        return left(
          ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      print("---------------- [🚨 CRITICAL ERROR DURING REQUEST] ----------------");

      if (e is DioException) {
        print("🚩 DioException Type: ${e.type}");
        print("🚩 Dio Message: ${e.message}");
        print("🚩 Server Response Data: ${e.response?.data}");
        print("🚩 Status Code: ${e.response?.statusCode}");
        print("---------------- [🏁 END REQUEST - DIO ERROR] ----------------");
        return left(ServierFailur.fromDioError(e));
      }

      print("🚩 General Error: ${e.toString()}");
      print("---------------- [🏁 END REQUEST - GENERAL ERROR] ----------------");
      return left(ServierFailur(e.toString(), 500));
    }
  }
}
