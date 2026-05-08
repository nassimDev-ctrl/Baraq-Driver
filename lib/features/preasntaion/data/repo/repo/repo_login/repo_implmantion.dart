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
        
        final String? token = response.data["data"]?["token"];

        if (token != null && token.isNotEmpty) {
          await CacheManager.saveData('token', token);
          print(
            "🔑 [Token Saved]: تم استخراج التوكن من data['token'] وحفظه بنجاح",
          );
        } else {
          print(
            "⚠️ [Token Warning]: لم يتم العثور على التوكن في المسار response.data['data']['token']",
          );
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
}
