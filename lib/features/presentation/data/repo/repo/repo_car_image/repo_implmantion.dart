import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_service.dart';

import 'package:drever_warr/core/service/failure.dart';
import 'dart:io';

import 'package:drever_warr/features/presentation/data/repo/repo/repo_car_image/repo.dart';
 
class ImplementRepoUploadId extends RepoUploadId {
  final ApiService _apiService;

  ImplementRepoUploadId({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<Either<Failure, dynamic>> uploadDriverIdImages({
    required File frontImage,
    required File backImage,
  }) async {
    AppLogger.debug("📤 [REPO]: Starting ID Images Upload...");

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

      AppLogger.debug("🌐 >>> [API REQUEST: UPLOAD ID] <<< 🌐");
      AppLogger.debug("🔗 URL: /drivers/upload-driver-personal-card");
      AppLogger.debug("📦 Files: Front and Back ID images attached.");

      Response response = await _apiService.postdata(
        "/drivers/upload-driver-personal-card",
        data: formData,
        needToken: true,  
        isfromdata: true,
      );

      AppLogger.debug("✅ <<< [API RESPONSE] >>> ✅");
      AppLogger.debug("🔢 Status: ${response.statusCode}");
      AppLogger.debug("📄 Data: ${response.data}");

      if (response.data["success"] == true) {
        return right(response.data);
      } else {
        return left(ServerFailure.fromResponse(response.statusCode ?? 400, response.data));
      }
    } catch (e) {
      AppLogger.debug("❌ [UPLOAD EXCEPTION]: $e");
      if (e is DioException) return left(ServerFailure.fromDioError(e));
      return left(ServerFailure('حدث خطأ أثناء رفع صور الهوية', 500));
    }
  }
}