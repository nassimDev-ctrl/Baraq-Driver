import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';

abstract class ScheduledAcceptOrderRepo {
  Future<Either<Failure, Map<String, dynamic>>> acceptScheduledTrip({
    required String tripId,
  });
}