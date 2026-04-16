import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'dart:io';

import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_car_image/repo.dart';
 
class ImplementRepoUploadId extends RepoUploadId {
  final ApiService _apiService;

  ImplementRepoUploadId({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<Either<Failur, dynamic>> uploadDriverIdImages({
    required File frontImage,
    required File backImage,
  }) async {
    print("📤 [REPO]: Starting ID Images Upload...");

    try {
     
      FormData formData = FormData.fromMap({
        "personal_card_front": await MultipartFile.fromFile(
          frontImage.path,
          filename: frontImage.path.split('/').last,
        ),
        "personal_card_back": await MultipartFile.fromFile(
          backImage.path,
          filename: backImage.path.split('/').last,
        ),
      });

      print("🌐 >>> [API REQUEST: UPLOAD ID] <<< 🌐");
      print("🔗 URL: /drivers/upload-driver-personal-card");
      print("📦 Files: Front and Back ID images attached.");

      Response response = await _apiService.postdata(
        "/drivers/upload-driver-personal-card",
        data: formData,
        needToken: true,  
        isfromdata: true,
      );

      print("✅ <<< [API RESPONSE] >>> ✅");
      print("🔢 Status: ${response.statusCode}");
      print("📄 Data: ${response.data}");

      if (response.data["success"] == true) {
        return right(response.data);
      } else {
        return left(ServierFailur.fromResponse(response.statusCode ?? 400, response.data));
      }
    } catch (e) {
      print("❌ [UPLOAD EXCEPTION]: $e");
      if (e is DioException) return left(ServierFailur.fromDioError(e));
      return left(ServierFailur('حدث خطأ أثناء رفع صور الهوية', 500));
    }
  }
}