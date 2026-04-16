import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_forget_passwrd/repo.dart';
 
 
 

class ConfirmPasswordRepoImpl extends ConfirmPasswordRepo {
  final ApiService _apiService;
  ConfirmPasswordRepoImpl(this._apiService);

  @override
  Future<Either<Failur, dynamic>> confirmPassword({
    required String mobilphone,
    required String password,
  }) async {
    final Map<String, dynamic> body = {
      "newPassword": password,
      "mobilePhone": mobilphone,
    };

   
    print("🚀 [API START]: Confirm Password");
    print("🔗 [URL]: https://api.waslninow.com/auth-users/reset-password");
    print("📦 [Payload Body]: $body");

    try {
      Response response = await _apiService.put(
        endPoint: "auth-users/reset-password",
        data: body,
        isfromdata: false,
        
      );

     
      print("✅ [API SUCCESS]");
      print("🔢 [Status Code]: ${response.statusCode}");
      print("📄 [Response Data]: ${response.data}");

      if (response.data["success"] == true) {
        return right(response.data);
      } else {
        print("⚠️ [API LOGIC ERROR]: Success field is false");
        return left(
          ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      
      print("❌ [API EXCEPTION]");

      if (e is DioException) {
        print("🛑 [Dio Error Type]: ${e.type}");
        print("🔢 [Error Status Code]: ${e.response?.statusCode}");
        print("📄 [Error Response Body]: ${e.response?.data}");
        print("📧 [Error Message]: ${e.message}");
        return left(ServierFailur.fromDioError(e));
      } else {
        print("🛠️ [General Exception]: ${e.toString()}");
        return left(ServierFailur('حدث خطأ غير متوقع: ${e.toString()}', 500));
      }
    }
  }
}
