import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';

abstract class TripRepository {
  Future<Either<Failur, String>> startTrip({required String tripId});
}