import 'dart:developer';  
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/cash/preferences_service.dart';
import 'package:drever_warr/core/service/api_service.dart';
import 'package:drever_warr/core/service/failure.dart';
import 'package:drever_warr/features/setting/data/repo/repo_updet_phone.dart/repo.dart';
 

class RepoUpdateMobileImpl extends RepoUpdateMobile {
  final ApiService _apiService;
  RepoUpdateMobileImpl(this._apiService);

  @override
  @override
  Future<Either<Failure, String>> confirmPassword(String password) async {
    try {
      log('--- [START] Confirm Password Request ---');

      
      String? checkToken = await CacheManager.getData('token');
      log('📌 Current Token in Repo before call: $checkToken');

      var response = await _apiService.postdata(
        "auth-users/confirm-password",
        data: {"password": password},
        needToken: true,
        isfromdata: false,  
      );

       
      final resData = response.data;
      log('✅ [SERVER RESPONSE]: $resData');

      if (resData['success'] == true) {
        return right(resData['message'] ?? "تم التأكيد");
      } else {
        return left(ServerFailure(resData['message'] ?? "خطأ في التأكيد", 400));
      }
    } catch (e) {
      if (e is DioException) {
        log('📡 [DIO ERROR DATA]: ${e.response?.data}');
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failure, String>> updateMobilePhone(
    String newMobile,
    String code,
  ) async {
    try {
      log('--- [START] Update Mobile Phone Request ---');
      log('🔗 Endpoint: auth-users/update-mobile-phone');
      log('📱 New Mobile: $newMobile');
      log('🔢 Code: $code');

      var response = await _apiService.put(
        endPoint: "auth-users/update-mobile-phone",
        data: {"mobilePhone": newMobile, "code": code},
        isfromdata: false,
      );

      
      final resData = response.data;
      log('✅ [SERVER RESPONSE DATA]: $resData');

     
      if (resData['success'] == true) {
        return right(resData['message'] ?? "تم تحديث رقم الهاتف بنجاح");
      } else {
        return left(ServerFailure(resData['message'] ?? "فشل التحديث", 400));
      }
    } catch (e) {
      log('❌ [EXCEPTION] in updateMobilePhone');
      if (e is DioException) {
        log('📡 [DIO ERROR]: ${e.response?.data}');
        return left(ServerFailure.fromDioError(e));
      }
      log('⚠️ [UNKNOWN ERROR]: ${e.toString()}');
      return left(ServerFailure("حدث خطأ غير متوقع", 500));
    }
  }
}
