import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/repo/logout_repo/repo.dart';

class LogoutRepositoryImpl implements LogoutRepository {
  final ApiService apiService;

  LogoutRepositoryImpl(this.apiService);

  @override
  Future<Either<Failur, String>> logout() async {
    print("---------------- [🚪 LOGOUT REQUEST] ----------------");
    print("🔗 Endpoint: auth-users/logout");
    print("🔑 Status: Sending GET Request...");

    try {
      final response = await apiService.get(
        endpoint: 'auth-users/logout',
        needToken: true,
      );

      print("✅ [SUCCESS] Server Responded Successfully");
      print("📦 Response Body: ${response.data}");

      String message = "Logged out successfully";

      if (response.data is Map<String, dynamic>) {
        message = response.data['message'] ?? message;
      }

      print("💬 Final Message: $message");
      print("------------------------------------------------------------");

      return right(message);
    } catch (e) {
      print("❌ [FAILURE] Error in logout");

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