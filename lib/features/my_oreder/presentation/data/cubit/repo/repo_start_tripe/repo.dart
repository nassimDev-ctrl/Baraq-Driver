import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';

abstract class TripRepository {
  Future<Either<Failure, String>> startTrip({required String tripId});
}