import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/cash/preferences_service.dart';

import 'package:drever_warr/core/service/api_service.dart';

import 'package:drever_warr/core/service/failure.dart';

import 'package:drever_warr/features/presentation/data/repo/repo/repo_login/repo.dart';

import '../../../../../../core/utils/normalize_number.dart';

class ImplementRepoLogin extends RepoLogin {
  final ApiService _apiService;

  ImplementRepoLogin({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<Either<Failure, dynamic>> login({
    required String mobilePhone,
    required String password,
  }) async {
    final phone = normalizePhone(mobilePhone);
    final Map<String, dynamic> loginData = {
      "mobilePhone": phone,
      "password": password,
    };

    AppLogger.debug("🚀 [POST Request] Endpoint: auth-users/login");
    AppLogger.debug("📦 [Login Data]: $loginData");

    try {
      Response response = await _apiService.postdata(
        "/auth-users/login",
        data: loginData,
        needToken: false,
        isfromdata: false,
      );

      AppLogger.debug("✅ [Response Received] Status Code: ${response.statusCode}");
      AppLogger.debug("📄 [Response Data]: ${response.data}");

      if (response.data["success"] == true || response.data["error"] == false) {
        final data = response.data["data"];
        final String? token = data is Map ? data["token"]?.toString() : null;
        final String? status = _extractDriverStatus(response.data);

        if (token != null && token.isNotEmpty) {
          await CacheManager.saveData(CacheManager.tokenKey, token);
          AppLogger.debug(
            "🔑 [Token Saved]: تم استخراج التوكن من data['token'] وحفظه بنجاح",
          );
        } else {
          AppLogger.debug(
            "⚠️ [Token Warning]: لم يتم العثور على التوكن في المسار response.data['data']['token']",
          );
        }

        if (status != null && status.isNotEmpty) {
          await CacheManager.saveData(CacheManager.statusKey, status);
          AppLogger.debug("status : $status");
          AppLogger.debug("💾 [STATUS SAVED]: STATUS has been stored in CacheManager.");
        } else {
          AppLogger.debug(
              "⚠️ [STATUS WARNING]: Success was true but no status found in response!");
        }

        return right(response.data);
      } else {
        AppLogger.debug("🛑 [Login Logic Error]: السيرفر أعاد حالة فشل");
        return left(
          ServerFailure.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      AppLogger.debug("❌ [Exception Caught in Login Repo]: $e");
      if (e is DioException) {
        AppLogger.debug("🔗 Error Details: ${e.response?.data}");
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure('حدث خطأ أثناء تسجيل الدخول', 500));
    }
  }

  String? _extractDriverStatus(dynamic responseData) {
    if (responseData is! Map) return null;

    final data = responseData['data'];
    if (data is! Map) return null;

    final user = data['user'];
    if (user is Map) {
      final profile = user['profile'];
      if (profile is Map && profile['status'] != null) {
        return profile['status'].toString();
      }
      if (user['status'] != null) {
        return user['status'].toString();
      }
    }

    if (data['status'] != null) {
      return data['status'].toString();
    }

    return null;
  }
}