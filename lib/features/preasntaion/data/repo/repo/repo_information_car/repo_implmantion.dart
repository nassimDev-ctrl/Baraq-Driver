import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_servise.dart';

import 'package:drever_warr/core/service/failear.dart';
import 'dart:io';

import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_information_car/repo.dart';

class ImplementRepoCarInfo extends RepoCarInfo {
  final ApiService _apiService;

  ImplementRepoCarInfo({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failur, dynamic>> completeCarInfo({
    required File carImage,
    required File carPlateImage,
    required String carName,
    required String category,
    required String carColor,
    required String carPlateNumber,
    required String carYearMade,
  }) async {
    AppLogger.debug("\n🚀🚀🚀 START CAR INFO REQUEST 🚀🚀🚀");

    try {
     
      AppLogger.debug("📌 carName: $carName");
      AppLogger.debug("📌 category: $category");
      AppLogger.debug("📌 carPlateNumber: $carPlateNumber");
      AppLogger.debug("📌 carYearMade: $carYearMade");

      AppLogger.debug("📸 carImage path: ${carImage.path}");
      AppLogger.debug("📸 carPlateImage path: ${carPlateImage.path}");

      AppLogger.debug("📁 carImage exists: ${await carImage.exists()}");
      AppLogger.debug("📁 plateImage exists: ${await carPlateImage.exists()}");

      AppLogger.debug("📏 carImage size: ${await carImage.length()} bytes");
      AppLogger.debug("📏 plateImage size: ${await carPlateImage.length()} bytes");

      
      final carImageFile = await MultipartFile.fromFile(
        carImage.path,
        filename: carImage.path.split('/').last,
      );

      final plateImageFile = await MultipartFile.fromFile(
        carPlateImage.path,
        filename: carPlateImage.path.split('/').last,
      );

    
      FormData formData = FormData.fromMap({
        "car_image": carImageFile,
        "car_plate_image": plateImageFile,
        "carName": carName,
        "category": category,
        "carColor": carColor,
        "carPlateNumber": carPlateNumber,
        "carYearMade": carYearMade,
      });

      
      AppLogger.debug("\n📦📦 FORM DATA CONTENT 📦📦");
      for (var field in formData.fields) {
        AppLogger.debug("📝 FIELD => ${field.key}: ${field.value}");
      }

      for (var file in formData.files) {
        AppLogger.debug("📎 FILE => ${file.key}: ${file.value.filename}");
      }

      AppLogger.debug("\n🌐 >>> API REQUEST <<< 🌐");
      AppLogger.debug("🔗 URL: /drivers/complete-driver-car-info");

     
      Response response = await _apiService.postdata(
        "/drivers/complete-driver-car-info",
        data: formData,
        needToken: true,
        isfromdata: true,
      );

      AppLogger.debug("\n✅✅ RESPONSE SUCCESS ✅✅");
      AppLogger.debug("📊 Status Code: ${response.statusCode}");
      AppLogger.debug("📄 Response Data: ${response.data}");

      if (response.data["success"] == true) {
        return right(response.data);
      } else {
        AppLogger.debug("❌ السيرفر رجع success = false");
        return left(
          ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      AppLogger.debug("\n❌❌❌ ERROR OCCURRED ❌❌❌");

      if (e is DioException) {
        AppLogger.error("📛 DioException Type: ${e.type}");
        AppLogger.debug("📛 Message: ${e.message}");

        if (e.response != null) {
          AppLogger.debug("📊 Status Code: ${e.response?.statusCode}");
          AppLogger.debug("📄 Response Data: ${e.response?.data}");
          AppLogger.debug("📑 Headers: ${e.response?.headers}");
        } else {
          AppLogger.debug("⚠️ No response received from server");
        }

        AppLogger.debug("📦 Request Data: ${e.requestOptions.data}");
        AppLogger.debug("🔗 Path: ${e.requestOptions.path}");
        AppLogger.debug("📑 Headers Sent: ${e.requestOptions.headers}");

        return left(ServierFailur.fromDioError(e));
      }

      AppLogger.error("🔥 Unknown Error: $e");
      return left(ServierFailur('حدث خطأ أثناء إرسال بيانات السيارة', 500));
    } finally {
      AppLogger.debug("🏁🏁🏁 END REQUEST 🏁🏁🏁\n");
    }
  }
}