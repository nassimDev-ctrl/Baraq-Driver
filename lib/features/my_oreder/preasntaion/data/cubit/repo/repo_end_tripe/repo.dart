import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';

abstract class EndTripRepository {
  Future<Either<Failur, String>> completeTrip({required String tripId});
}