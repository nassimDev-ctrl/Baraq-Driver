import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/repo/complain_repo/repo.dart';
import 'package:path/path.dart' as path;

class AddComplainRepositoryImpl implements AddComplainRepository {
  final ApiService apiService;

  AddComplainRepositoryImpl(this.apiService);

  @override
  Future<Either<Failur, String>> sendComplain({
    required String description,
    File? image,
  }) async {
    print("---------------- [📝 SEND COMPLAINT REQUEST] ----------------");
    print("📄 Description: $description");
    print("🖼️ Image Exists: ${image != null}");
    print("🔗 Endpoint: complains/create");
    print("🔑 Status: Sending POST Request...");

    try {
      final formData = FormData.fromMap({
        "note": description,
        if (image != null)
          "complain_image": await MultipartFile.fromFile(
            image.path,
            filename: path.basename(image.path),
          ),
      });

      final response = await apiService.postdata(
        'complains/create',
        data: formData,
        needToken: true,
        isfromdata: true,
      );

      print("✅ [SUCCESS] Server Responded Successfully");
      print("📦 Response Body: ${response.data}");

      String message = "Complaint sent successfully";

      if (response.data is Map<String, dynamic>) {
        message = response.data['message'] ?? message;
      }

      print("💬 Final Message: $message");
      print("------------------------------------------------------------");

      return right(message);
    } catch (e) {
      print("❌ [FAILURE] Error in sendComplain");

      if (e is DioException) {
        final failure = ServierFailur.fromDioError(e);
        print("🚨 Dio Error Type: ${e.type}");
        print("🚨 Status Code: ${e.response?.statusCode}");
        print("🚨 Error Data from Server: ${e.response?.data}");
        print("🚨 Failure Message: ${failure.errMassage}");
        print("------------------------------------------------------------");
        return left(failure);
      }

      print("🚨 Unexpected Error: ${e.toString()}");
      print("------------------------------------------------------------");
      return left(ServierFailur(e.toString(), 500));
    }
  }
}