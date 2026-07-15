import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
import 'package:drever_warr/features/my_tripe/data/model/single_finished_trip.dart';

abstract class SingleTripDetailsRepository {
  Future<Either<Failure, SingleFinishedTripModel>> getTripById({
    required String tripId,
  });
}