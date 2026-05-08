import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/cash/preferences_servis.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo.dart';
// استيراد الـ CacheManager (تأكد من صحة المسار)
 
class ImplementRepoRegister extends RepoRegister {
  final ApiService _apiService;

  ImplementRepoRegister({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<Either<Failur, dynamic>> register({
    required Map<String, dynamic> userData,
  }) async {
    print("🚀 [POST Request] Endpoint: /drivers/register");
    print("📦 [Request Data]: $userData");

    try {
      Response response = await _apiService.postdata(
        "/drivers/register",
        data: userData,
        needToken: false,
        isfromdata: false,
      );

      print("✅ [Response Received] Status Code: ${response.statusCode}");
      print("📄 [Response Data]: ${response.data}");

      if (response.data["success"] == true) {
       
        final String? token = response.data['data']?['token'] ?? response.data['token'];
        
        if (token != null) {
          await CacheManager.saveData("token", token);
          print("token : $token");
          print("💾 [TOKEN SAVED]: Token has been stored in CacheManager.");
        } else {
          print("⚠️ [TOKEN WARNING]: Success was true but no token found in response!");
        }
       

        print("🎉 [Register Success]");
        return right(response.data);
      } else {
        print("⚠️ [Logic Error from Server]: ${response.data}");
        return left(
          ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      print("❌ [Exception Caught in Repo]: $e");

      if (e is DioException) {
        print("🔴 [Dio Error Type]: ${e.type}");
        print("🔴 [Dio Error Response]: ${e.response?.data}");
        return left(ServierFailur.fromDioError(e));
      }
      return left(ServierFailur('حدث خطأ أثناء التسجيل', 500));
    }
  }
}