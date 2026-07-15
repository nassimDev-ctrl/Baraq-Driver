import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
import '../../models/trip_response_model.dart';

abstract class TripDetailsRepository {
  Future<Either<Failure, TripResponseModel>> getTripDetails({
    required String tripId,
  });

  Future<Either<Failure, bool>> isClientConfirmed({
    required String tripId,
  });
}