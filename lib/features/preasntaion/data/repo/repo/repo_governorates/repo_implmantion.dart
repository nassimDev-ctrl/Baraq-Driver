import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/logging/app_logger.dart';

import 'package:dio/dio.dart';

import 'package:drever_warr/core/service/api_servise.dart';

import 'package:drever_warr/core/service/failear.dart';

import 'package:drever_warr/features/preasntaion/data/repo/model/model_governorates.dart';

import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_governorates/repo.dart';

class RepoGovernoratesImpl extends RepoGovernorates {
  final ApiService _apiService;

  RepoGovernoratesImpl(this._apiService);

  @override
  Future<Either<Failur, List<GovernorateModel>>> fetchGovernorates() async {
    try {
      AppLogger.error("🚀 [GET Request] Endpoint: governorates");

     
      var response = await _apiService.get(
        endpoint: "/cities", 
        needToken: false,
      );

      AppLogger.debug("✅ [Governorates Response]: ${response.data}");

      if (response.data["success"] == true) {
        List<GovernorateModel> governorates = [];
        
     
        var items = response.data["cities"] as List; 
        
        for (var item in items) {
          governorates.add(GovernorateModel.fromJson(item));
        }
        return right(governorates);
      } else {
        return left(
          ServierFailur.fromResponse(response.statusCode ?? 400, response.data),
        );
      }
    } catch (e) {
      AppLogger.debug("❌ [Exception in Governorates Repo]: $e");
      if (e is DioException) {
        return left(ServierFailur.fromDioError(e));
      }
      return left(ServierFailur(e.toString(), 500));
    }
  }
}