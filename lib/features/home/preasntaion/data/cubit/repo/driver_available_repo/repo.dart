import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/api_servise.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'dart:developer' as dev;

abstract class DriverStatusRepository {
  Future<Either<Failur, bool>> getDriverAvailability();
  Future<Either<Failur, bool>> setDriverAvailability(bool isAvailable);
}

class DriverStatusRepositoryImpl implements DriverStatusRepository {
  final ApiService apiService;

  DriverStatusRepositoryImpl(this.apiService);

  @override
  Future<Either<Failur, bool>> getDriverAvailability() async {
    try {
      dev.log('🚀 [GET] Checking driver availability...', name: 'DriverStatusRepo');

      final response = await apiService.get(
        endpoint: '/drivers/check-activate-driver',
        needToken: true,
      );

      dev.log('✅ [Raw Response]: ${response.data}', name: 'DriverStatusRepo');

      final data = response.data;
      final isAvailable = data['data']?['isAvailable'] ?? false;

      return right(isAvailable);
    } catch (e) {
      dev.log('❌ [GET Error]: $e', name: 'DriverStatusRepo', error: e);
      return left(ServierFailur(e.toString(), 500));
    }
  }

  @override
  Future<Either<Failur, bool>> setDriverAvailability(bool isAvailable) async {
    try {
      dev.log(
        '🚀 [PUT] Updating driver availability to $isAvailable',
        name: 'DriverStatusRepo',
      );

      final response = await apiService.put(
        endPoint: '/drivers/activate-driver',
        data: {
          "isAvailable": isAvailable,
        }, isfromdata: false,
      );

      dev.log('✅ [Raw Response]: ${response.data}', name: 'DriverStatusRepo');

      final data = response.data;
      final updated = data['data']?['isAvailable'] ?? isAvailable;

      return right(updated);
    } catch (e) {
      dev.log('❌ [PUT Error]: $e', name: 'DriverStatusRepo', error: e);
      return left(ServierFailur(e.toString(), 500));
    }
  }
}