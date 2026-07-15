import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_service.dart';

import 'package:drever_warr/core/service/failure.dart';

import 'package:drever_warr/features/home/presentation/data/cubit/repo/complain_repo/repo.dart';

import 'package:path/path.dart' as path;

class AddComplainRepositoryImpl implements AddComplainRepository {
  final ApiService apiService;

  AddComplainRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, String>> sendComplain({
    required String description,
    File? image,
  }) async {
    AppLogger.debug("---------------- [📝 SEND COMPLAINT REQUEST] ----------------");
    AppLogger.debug("📄 Description: $description");
    AppLogger.debug("🖼️ Image Exists: ${image != null}");
    AppLogger.debug("🔗 Endpoint: complains/create");
    AppLogger.debug("🔑 Status: Sending POST Request...");

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

      AppLogger.debug("✅ [SUCCESS] Server Responded Successfully");
      AppLogger.debug("📦 Response Body: ${response.data}");

      String message = "Complaint sent successfully";

      if (response.data is Map<String, dynamic>) {
        message = response.data['message'] ?? message;
      }

      AppLogger.debug("💬 Final Message: $message");
      AppLogger.debug("------------------------------------------------------------");

      return right(message);
    } catch (e) {
      AppLogger.debug("❌ [FAILURE] Error in sendComplain");

      if (e is DioException) {
        final failure = ServerFailure.fromDioError(e);
        AppLogger.error("🚨 Dio Error Type: ${e.type}");
        AppLogger.error("🚨 Status Code: ${e.response?.statusCode}");
        AppLogger.debug("🚨 Error Data from Server: ${e.response?.data}");
        AppLogger.error("🚨 Failure Message: ${failure.errMessage}");
        AppLogger.error("------------------------------------------------------------");
        return left(failure);
      }

      AppLogger.error("🚨 Unexpected Error: ${e.toString()}");
      AppLogger.error("------------------------------------------------------------");
      return left(ServerFailure(e.toString(), 500));
    }
  }
}