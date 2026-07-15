import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_servise.dart';

import 'package:drever_warr/core/service/failear.dart';

import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_verificationRepo/repo.dart';
 
 

class VerificationRepoImpl extends VerificationRepo {
  final ApiService _apiService;

  VerificationRepoImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<Either<Failur, dynamic>> createVerificationCode({
    required String mobilePhone,
    required String typeOfUse,
  }) async {
    final Map<String, dynamic> body = {
      "mobilePhone": mobilePhone,
      "typeOfUse": typeOfUse,
    };

    _printRequestLog("CREATE CODE", "/verification-codes/create", body);

    try {
      Response response = await _apiService.postdata(
        "/verification-codes/create",
        data: body,
        needToken: false,
        isfromdata: false,
      );

      _printResponseLog("CREATE CODE SUCCESS", response);

      if (response.data["success"] == true) {
        return right(response.data);
      } else {
        return left(
          ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      _handleDetailedError("CREATE CODE EXCEPTION", e);
      if (e is DioException) return left(ServierFailur.fromDioError(e));
      return left(ServierFailur('حدث خطأ غير متوقع', 500));
    }
  }

  @override
  Future<Either<Failur, dynamic>> verifyMobileNumber({
    required String mobilePhone,
    required String typeOfUse,
    required String code,
  }) async {
    final Map<String, dynamic> body = {
      "mobilePhone": mobilePhone,
      "typeOfUse": typeOfUse,
      "code": code,
    };

    _printRequestLog(
      "VERIFY CODE",
      "/verification-codes/verify-mobile-phone-number",
      body,
    );

    try {
      Response response = await _apiService.postdata(
        "/verification-codes/verify-mobile-phone-number",
        data: body,
        needToken: false,
        isfromdata: false,
      );

      _printResponseLog("VERIFY CODE SUCCESS", response);

      if (response.data["success"] == true) {
        return right(response.data);
      } else {
        return left(
          ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      _handleDetailedError("VERIFY CODE EXCEPTION", e);
      if (e is DioException) return left(ServierFailur.fromDioError(e));
      return left(ServierFailur('حدث خطأ أثناء التأكيد', 500));
    }
  }

   

  void _printRequestLog(String label, String url, dynamic body) {
    AppLogger.debug("🌐 >>> [API REQUEST: $label] <<< 🌐");
    AppLogger.debug("🔗 URL: $url");
    AppLogger.debug("📤 BODY: $body");
    AppLogger.debug("-----------------------------------------");
  }

  void _printResponseLog(String label, Response response) {
    AppLogger.debug("✅ <<< [API RESPONSE: $label] >>> ✅");
    AppLogger.debug("🔢 STATUS: ${response.statusCode}");
    AppLogger.debug("📄 DATA: ${response.data}");
    AppLogger.debug("-----------------------------------------");
  }

  void _handleDetailedError(String label, dynamic e) {
    AppLogger.error("❌ !!! [API ERROR: $label] !!! ❌");
    if (e is DioException) {
      AppLogger.error("⚠️ Type: ${e.type}");
      AppLogger.debug("💬 Message: ${e.message}");
      if (e.response != null) {
        AppLogger.debug("🔢 Status Code: ${e.response?.statusCode}");
        AppLogger.debug("📄 Error Body: ${e.response?.data}");
        AppLogger.error("🚩 Headers: ${e.response?.headers}");
      }
    } else {
      AppLogger.debug("🌪️ Raw Error: $e");
    }
    AppLogger.error("-----------------------------------------");
  }
}