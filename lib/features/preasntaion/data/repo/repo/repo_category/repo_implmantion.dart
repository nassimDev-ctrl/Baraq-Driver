import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_servise.dart';

import 'package:drever_warr/core/service/failear.dart';

import 'package:drever_warr/features/preasntaion/data/repo/model/model_category.dart';

import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_category/repo.dart';

class RepoCarCategoryImpl extends RepoCarCategory {
  final ApiService _apiService;
  RepoCarCategoryImpl(this._apiService);

  @override
  Future<Either<Failur, List<CarCategoryModel>>> fetchCarCategories() async {
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
        return left(ServierFailur("لا توجد بيانات للفئات", 400));
      }
    } catch (e) {
      AppLogger.debug("❌ [Exception in CarCategory Repo]: ${e.toString()}");
      if (e is DioException) {
        return left(ServierFailur.fromDioError(e));
      }
      return left(ServierFailur(e.toString(), 500));
    }
  }
}