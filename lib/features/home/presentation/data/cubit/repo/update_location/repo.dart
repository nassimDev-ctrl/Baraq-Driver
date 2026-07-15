import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
import '../../model/update_location_response_model.dart';

abstract class DriverLocationRepository {
  Future<Either<Failure, UpdateLocationResponseModel>> updateDriverLocation({
    required double longitude,
    required double latitude,
    required String address,
  });
  Future<Either<Failure, UpdateLocationResponseModel>> updateDriverLocationForTrip({
    required String tripId,
    required double longitude,
    required double latitude,
    required String address,
  });

  Future<Either<Failure, UpdateLocationResponseModel>> updateEmergencyLocationForTrip({
    required String tripId,
    required double longitude,
    required double latitude,
    required String address,
  });
}
