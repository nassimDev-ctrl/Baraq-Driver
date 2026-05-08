import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
import '../../models/trip_response_model.dart';

abstract class TripDetailsRepository {
  Future<Either<Failur, TripResponseModel>> getTripDetails({
    required String tripId,
  });

  Future<Either<Failur, bool>> isClientConfirmed({
    required String tripId,
  });
}