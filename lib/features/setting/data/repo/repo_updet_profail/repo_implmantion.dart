 

import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/setting/data/repo/repo_updet_profail/repo.dart';

class UpdateProfileRepoImpl implements UpdateProfileRepo {
  final ApiService _apiService;
  UpdateProfileRepoImpl(this._apiService);

  @override
  Future<Either<Failur, String>> updateProfile({
    required String firstName,
    required String lastName,
    required String governorate,
    required String category,
    String? imagePath,
  }) async {
    try {
   
      log("-----------------------------------------");
      log("🚀 [API START]: Update Profile with Image");
      log("🔗 [Endpoint]: /drivers/update-driver");
      log(
        "📦 [Text Data]: { firstName: $firstName, lastName: $lastName, city: $governorate }",
      );
      log("🖼️ [Image Path]: ${imagePath ?? 'No image selected'}");
      log("-----------------------------------------");

     
      Map<String, dynamic> dataMap = {
        "firstName": firstName,
        "lastName": lastName,
        "city": governorate,
        "newCategory": category,
      };

     
      FormData formData = FormData.fromMap(dataMap);

     
      if (imagePath != null && imagePath.isNotEmpty) {
       
        formData.files.add(
          MapEntry(
            "profile_image",
            await MultipartFile.fromFile(
              imagePath,
              
            ),
          ),
        );
        log("✅ [Image Added to FormData]");
      }

      
      var response = await _apiService.put(
        endPoint: "/drivers/update-driver",
        data: formData, 
        isfromdata: true,  
      );

     
      log("✅ [API SUCCESS]");
      log("🔢 [Status Code]: ${response.statusCode}");
      log("📄 [Response Body]: ${response.data}");

      if (response.data['success'] == true) {
        return right(response.data['message'] ?? "تم تحديث الملف الشخصي بنجاح");
      } else {
        log("⚠️ [SERVER LOGIC ERROR]: ${response.data['message']}");
        return left(
          ServierFailur(response.data['message'] ?? "فشل التحديث", 400),
        );
      }
    } catch (e) {
      log("❌ [API EXCEPTION OCCURRED]");
      if (e is DioException) {
        log("🛑 [Dio Error Type]: ${e.type}");
        log("🔢 [Error Status Code]: ${e.response?.statusCode}");
        log("📄 [Error Response Body]: ${e.response?.data}");
        return left(ServierFailur.fromDioError(e));
      }
      log("🚨 [UNKNOWN ERROR]: ${e.toString()}");
      return left(ServierFailur("حدث خطأ غير متوقع", 500));
    } finally {
      log("🏁 [API END]: Update Profile Finished");
      log("-----------------------------------------");
    }
  }
}
