import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';

abstract class EndTripRepository {
  Future<Either<Failure, String>> completeTrip({required String tripId});
}