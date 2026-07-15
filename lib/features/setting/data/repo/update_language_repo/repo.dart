import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/api_service.dart';
import 'package:drever_warr/core/service/failure.dart';
import 'dart:developer' as dev;

abstract class LanguageRepository {
  Future<Either<Failure, String>> changeLanguage(String languageCode);
}

class LanguageRepositoryImpl implements LanguageRepository {
  final ApiService apiService;

  LanguageRepositoryImpl(this.apiService);

  @override
  Future<Either<Failure, String>> changeLanguage(String languageCode) async {
    try {
      dev.log('🌐 [PUT Request] Changing language to $languageCode',
          name: 'LanguageRepo');

      final response = await apiService.put(
        endPoint: '/auth-users/change-language',
        data: {
          "language": languageCode,
        },
        isfromdata: false,
      );

      dev.log('✅ [Raw Response]: ${response.data}', name: 'LanguageRepo');

      return right("Language updated successfully");
    } catch (e) {
      dev.log('❌ [Catch Error]: $e', name: 'LanguageRepo', error: e);
      return left(ServerFailure(e.toString(), 500));
    }
  }
}