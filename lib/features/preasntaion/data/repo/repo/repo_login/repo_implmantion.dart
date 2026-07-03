import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/cash/preferences_servis.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_login/repo.dart';

import '../../../../../../core/utiles/normlize_number.dart';

class ImplementRepoLogin extends RepoLogin {
  final ApiService _apiService;

  ImplementRepoLogin({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<Either<Failur, dynamic>> login({
    required String mobilePhone,
    required String password,
  }) async {
    final phone = normalizePhone(mobilePhone);
    final Map<String, dynamic> loginData = {
      "mobilePhone": phone,
      "password": password,
    };

    print("🚀 [POST Request] Endpoint: auth-users/login");
    print("📦 [Login Data]: $loginData");

    try {
      Response response = await _apiService.postdata(
        "/auth-users/login",
        data: loginData,
        needToken: false,
        isfromdata: false,
      );

      print("✅ [Response Received] Status Code: ${response.statusCode}");
      print("📄 [Response Data]: ${response.data}");

      if (response.data["success"] == true || response.data["error"] == false) {
        final data = response.data["data"];
        final String? token = data is Map ? data["token"]?.toString() : null;
        final String? status = _extractDriverStatus(response.data);

        if (token != null && token.isNotEmpty) {
          await CacheManager.saveData(CacheManager.tokenKey, token);
          print(
            "🔑 [Token Saved]: تم استخراج التوكن من data['token'] وحفظه بنجاح",
          );
        } else {
          print(
            "⚠️ [Token Warning]: لم يتم العثور على التوكن في المسار response.data['data']['token']",
          );
        }

        if (status != null && status.isNotEmpty) {
          await CacheManager.saveData(CacheManager.statusKey, status);
          print("status : $status");
          print("💾 [STATUS SAVED]: STATUS has been stored in CacheManager.");
        } else {
          print(
              "⚠️ [STATUS WARNING]: Success was true but no status found in response!");
        }

        return right(response.data);
      } else {
        print("🛑 [Login Logic Error]: السيرفر أعاد حالة فشل");
        return left(
          ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      print("❌ [Exception Caught in Login Repo]: $e");
      if (e is DioException) {
        print("🔗 Error Details: ${e.response?.data}");
        return left(ServierFailur.fromDioError(e));
      }
      return left(ServierFailur('حدث خطأ أثناء تسجيل الدخول', 500));
    }
  }

  String? _extractDriverStatus(dynamic responseData) {
    if (responseData is! Map) return null;

    final data = responseData['data'];
    if (data is! Map) return null;

    final user = data['user'];
    if (user is Map) {
      final profile = user['profile'];
      if (profile is Map && profile['status'] != null) {
        return profile['status'].toString();
      }
      if (user['status'] != null) {
        return user['status'].toString();
      }
    }

    if (data['status'] != null) {
      return data['status'].toString();
    }

    return null;
  }
}
