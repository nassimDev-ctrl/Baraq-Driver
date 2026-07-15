import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_service.dart';

import 'package:drever_warr/core/service/failure.dart';

import 'package:drever_warr/features/presentation/data/repo/model/model_category.dart';

import 'package:drever_warr/features/presentation/data/repo/repo/repo_category/repo.dart';

class RepoCarCategoryImpl extends RepoCarCategory {
  final ApiService _apiService;
  RepoCarCategoryImpl(this._apiService);

  @override
  Future<Either<Failure, List<CarCategoryModel>>> fetchCarCategories() async {
    try {
      AppLogger.error("🚀 [CarCategory Repo]: البدء بجلب البيانات...");

      var response = await _apiService.get(
        endpoint: "/car-categories",
        needToken: true, 
      );

      AppLogger.debug("✅ [Response Data]: ${response.data}");

    
      if (response.data != null && response.data["carCategories"] != null) {
        List<CarCategoryModel> categories = [];

        
        var items = response.data["carCategories"] as List;

        AppLogger.debug("📦 [Items Count]: ${items.length} categories found.");

        for (var item in items) {
          categories.add(CarCategoryModel.fromJson(item));
        }

        return right(categories);
      } else {
        AppLogger.debug(
          "⚠️ [Key Error]: المفتاح 'carCategories' غير موجود أو السيرفر أرجع نجاح كاذب",
        );
        return left(ServerFailure("لا توجد بيانات للفئات", 400));
      }
    } catch (e) {
      AppLogger.debug("❌ [Exception in CarCategory Repo]: ${e.toString()}");
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString(), 500));
    }
  }
}