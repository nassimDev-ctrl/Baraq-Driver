import 'package:dartz/dartz.dart';
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
    required String carPlateNumber,
    required String carYearMade,
  }) async {
    print("\n🚀🚀🚀 START CAR INFO REQUEST 🚀🚀🚀");

    try {
     
      print("📌 carName: $carName");
      print("📌 category: $category");
      print("📌 carPlateNumber: $carPlateNumber");
      print("📌 carYearMade: $carYearMade");

      print("📸 carImage path: ${carImage.path}");
      print("📸 carPlateImage path: ${carPlateImage.path}");

      print("📁 carImage exists: ${await carImage.exists()}");
      print("📁 plateImage exists: ${await carPlateImage.exists()}");

      print("📏 carImage size: ${await carImage.length()} bytes");
      print("📏 plateImage size: ${await carPlateImage.length()} bytes");

      
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
        "carColor": "ؤؤؤؤ",
        "carPlateNumber": carPlateNumber,
        "carYearMade": carYearMade,
      });

      
      print("\n📦📦 FORM DATA CONTENT 📦📦");
      formData.fields.forEach((field) {
        print("📝 FIELD => ${field.key}: ${field.value}");
      });

      for (var file in formData.files) {
        print("📎 FILE => ${file.key}: ${file.value.filename}");
      }

      print("\n🌐 >>> API REQUEST <<< 🌐");
      print("🔗 URL: /drivers/complete-driver-car-info");

     
      Response response = await _apiService.postdata(
        "/drivers/complete-driver-car-info",
        data: formData,
        needToken: true,
        isfromdata: true,
      );

      print("\n✅✅ RESPONSE SUCCESS ✅✅");
      print("📊 Status Code: ${response.statusCode}");
      print("📄 Response Data: ${response.data}");

      if (response.data["success"] == true) {
        return right(response.data);
      } else {
        print("❌ السيرفر رجع success = false");
        return left(
          ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      print("\n❌❌❌ ERROR OCCURRED ❌❌❌");

      if (e is DioException) {
        print("📛 DioException Type: ${e.type}");
        print("📛 Message: ${e.message}");

        if (e.response != null) {
          print("📊 Status Code: ${e.response?.statusCode}");
          print("📄 Response Data: ${e.response?.data}");
          print("📑 Headers: ${e.response?.headers}");
        } else {
          print("⚠️ No response received from server");
        }

        print("📦 Request Data: ${e.requestOptions.data}");
        print("🔗 Path: ${e.requestOptions.path}");
        print("📑 Headers Sent: ${e.requestOptions.headers}");

        return left(ServierFailur.fromDioError(e));
      }

      print("🔥 Unknown Error: $e");
      return left(ServierFailur('حدث خطأ أثناء إرسال بيانات السيارة', 500));
    } finally {
      print("🏁🏁🏁 END REQUEST 🏁🏁🏁\n");
    }
  }
}
