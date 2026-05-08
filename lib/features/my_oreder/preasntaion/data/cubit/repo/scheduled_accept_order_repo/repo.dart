import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';

abstract class ScheduledAcceptOrderRepo {
  Future<Either<Failur, Map<String, dynamic>>> acceptScheduledTrip({
    required String tripId,
  });
}