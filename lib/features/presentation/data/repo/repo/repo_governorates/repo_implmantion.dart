import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:drever_warr/core/logging/app_logger.dart';
import 'package:drever_warr/core/service/api_service.dart';
import 'package:drever_warr/core/service/failure.dart';
import 'package:drever_warr/features/presentation/data/repo/model/model_governorates.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_governorates/repo.dart';

class RepoGovernoratesImpl extends RepoGovernorates {
  final ApiService _apiService;

  RepoGovernoratesImpl(this._apiService);

  @override
  Future<Either<Failure, List<GovernorateModel>>> fetchGovernorates() async {
    try {
      AppLogger.debug('[GET] governorates');

      final response = await _apiService.get(
        endpoint: 'governorates/',
        needToken: false,
      );

      final data = response.data;
      final rawList = data['governorates'] as List?;

      if (rawList != null) {
        final governorates = rawList
            .whereType<Map>()
            .map(
              (item) => GovernorateModel.fromJson(
                item.cast<String, dynamic>(),
              ),
            )
            .where((gov) => gov.id.isNotEmpty && gov.name.isNotEmpty)
            .toList();

        if (governorates.isNotEmpty) {
          return right(governorates);
        }
      }

      if (data['success'] == true) {
        return right([]);
      }

      return left(
        ServerFailure.fromResponse(response.statusCode ?? 400, data),
      );
    } catch (e) {
      AppLogger.debug('[Governorates Repo Error]: $e');
      if (e is DioException) {
        return left(ServerFailure.fromDioError(e));
      }
      return left(ServerFailure(e.toString(), 500));
    }
  }
}
