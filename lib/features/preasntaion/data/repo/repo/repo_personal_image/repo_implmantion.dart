import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

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
     
    AppLogger.debug("📤 [REPO]: Starting Image Upload...");
    AppLogger.debug("📁 [File Path]: ${imageFile.path}");
    AppLogger.debug("📏 [File Size]: ${await imageFile.length()} bytes");

    try {
     
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "profile_image": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      AppLogger.debug("🌐 >>> [API REQUEST: UPLOAD IMAGE] <<< 🌐");
      AppLogger.debug("🔗 URL: drivers/upload-driver-image");
      AppLogger.debug("📦 Payload: FormData with file: $fileName");
      AppLogger.debug("-----------------------------------------");

      Response response = await _apiService.postdata(
        "drivers/upload-driver-image",
        data: formData,
        needToken: true, 
        isfromdata: true,
      );

      
      AppLogger.debug("✅ <<< [API RESPONSE: SUCCESS] >>> ✅");
      AppLogger.debug("🔢 Status Code: ${response.statusCode}");
      AppLogger.debug("📄 Data: ${response.data}");
      AppLogger.debug("-----------------------------------------");

      if (response.data["success"] == true) {
        AppLogger.debug("🎉 [UPLOAD SUCCESSFUL]");
        return right(response.data);
      } else {
        AppLogger.debug("⚠️ [LOGIC ERROR]: Success field is false");
        AppLogger.error("💬 Message: ${response.data["message"]}");
        return left(
          ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
     
      AppLogger.debug("❌ !!! [API ERROR: EXCEPTION] !!! ❌");

      if (e is DioException) {
        AppLogger.error("! Type: ${e.type}");
        AppLogger.debug("🔢 Status Code: ${e.response?.statusCode}");
        AppLogger.debug("📄 Error Body: ${e.response?.data}");
        AppLogger.error("🚩 Message: ${e.message}");
        return left(ServierFailur.fromDioError(e));
      }

      AppLogger.error("‼️ Unknown Error: $e");
      return left(ServierFailur('حدث خطأ أثناء رفع الصورة', 500));
    }
  }
}