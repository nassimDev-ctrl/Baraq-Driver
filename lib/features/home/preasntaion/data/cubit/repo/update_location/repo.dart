import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
import '../../model/update_location_response_model.dart';

abstract class DriverLocationRepository {
  Future<Either<Failur, UpdateLocationResponseModel>> updateDriverLocation({
    required double longitude,
    required double latitude,
    required String address,
  });
  Future<Either<Failur, UpdateLocationResponseModel>> updateDriverLocationForTrip({
    required String tripId,
    required double longitude,
    required double latitude,
    required String address,
  });

  Future<Either<Failur, UpdateLocationResponseModel>> updateEmergencyLocationForTrip({
    required String tripId,
    required double longitude,
    required double latitude,
    required String address,
  });
}
