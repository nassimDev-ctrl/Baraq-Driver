import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';

abstract class AcceptTripRepo {
  Future<Either<Failur, Map<String, dynamic>>> acceptTrip({required String tripId});

}