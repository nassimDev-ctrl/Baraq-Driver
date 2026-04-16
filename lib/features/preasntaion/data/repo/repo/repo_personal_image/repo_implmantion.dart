import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'dart:io';

import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_personal_image/repo.dart';

class ImplementRepoUploadImage extends RepoUploadImage {
  final ApiService _apiService;

  ImplementRepoUploadImage({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failur, dynamic>> uploadDriverImage({
    required File imageFile,
  }) async {
     
    print("📤 [REPO]: Starting Image Upload...");
    print("📁 [File Path]: ${imageFile.path}");
    print("📏 [File Size]: ${await imageFile.length()} bytes");

    try {
     
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "profile_image": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      print("🌐 >>> [API REQUEST: UPLOAD IMAGE] <<< 🌐");
      print("🔗 URL: drivers/upload-driver-image");
      print("📦 Payload: FormData with file: $fileName");
      print("-----------------------------------------");

      Response response = await _apiService.postdata(
        "drivers/upload-driver-image",
        data: formData,
        needToken: true, 
        isfromdata: true,
      );

      
      print("✅ <<< [API RESPONSE: SUCCESS] >>> ✅");
      print("🔢 Status Code: ${response.statusCode}");
      print("📄 Data: ${response.data}");
      print("-----------------------------------------");

      if (response.data["success"] == true) {
        print("🎉 [UPLOAD SUCCESSFUL]");
        return right(response.data);
      } else {
        print("⚠️ [LOGIC ERROR]: Success field is false");
        print("💬 Message: ${response.data["message"]}");
        return left(
          ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
     
      print("❌ !!! [API ERROR: EXCEPTION] !!! ❌");

      if (e is DioException) {
        print("! Type: ${e.type}");
        print("🔢 Status Code: ${e.response?.statusCode}");
        print("📄 Error Body: ${e.response?.data}");
        print("🚩 Message: ${e.message}");
        return left(ServierFailur.fromDioError(e));
      }

      print("‼️ Unknown Error: $e");
      return left(ServierFailur('حدث خطأ أثناء رفع الصورة', 500));
    }
  }
}
