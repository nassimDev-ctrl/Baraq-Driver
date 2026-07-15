import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/my_tripe/data/model/single_finished_trip.dart';

abstract class SingleTripDetailsRepository {
  Future<Either<Failur, SingleFinishedTripModel>> getTripById({
    required String tripId,
  });
}