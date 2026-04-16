import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/setting/data/model/model_profail.dart';
import 'package:drever_warr/features/setting/data/repo/repo_profail/repo.dart';
 
class ImplementRepoProfile extends RepoProfile {
  final ApiService _apiService;

  ImplementRepoProfile({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failur, ProfileModel>> getProfile() async {
    print("--------------------------------------------------");
    print("🚀 [START REQUEST] Endpoint: clients/get-profile");

    try {
      Response response = await _apiService.get(
        endpoint: "/drivers/get-profile",
        needToken: true,
      );

      
      print("✅ [RESPONSE RECEIVED]");
      print("📌 Status Code: ${response.statusCode}");
      print("📄 Response Data: ${response.data}"); 

      if (response.data["success"] == true) {
        print("✨ [PARSING DATA] Converting JSON to ProfileModel...");

        final profileModel = ProfileModel.fromJson(response.data);

       
        print(
          "👤 User Name from Model: ${profileModel.data?.firstName} ${profileModel.data?.lastName}",
        );
        print("--------------------------------------------------");

        return right(profileModel);
      } else {
        print("⚠️ [SERVER ERROR] Success is false");
        print("📝 Error Message: ${response.data['message']}");
        return left(
          ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      print("❌ [EXCEPTION CAUGHT]");
      if (e is DioException) {
        print("🔌 Dio Error Type: ${e.type}");
        print("📥 Dio Error Response: ${e.response?.data}");
        print("🔢 Dio Status Code: ${e.response?.statusCode}");
        return left(ServierFailur.fromDioError(e));
      }

      print("🆘 Generic Error: ${e.toString()}");
      print("--------------------------------------------------");
      return left(
        ServierFailur('حدث خطأ أثناء جلب البيانات: ${e.toString()}', 500),
      );
    }
  }
}
