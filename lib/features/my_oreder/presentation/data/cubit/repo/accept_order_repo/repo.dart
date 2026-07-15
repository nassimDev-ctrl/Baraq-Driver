import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';

abstract class AcceptTripRepo {
  Future<Either<Failure, Map<String, dynamic>>> acceptTrip({required String tripId});

  Future<Either<Failure, Map<String, dynamic>>> acceptScheduledTrip({
    required String tripId,
  });
}