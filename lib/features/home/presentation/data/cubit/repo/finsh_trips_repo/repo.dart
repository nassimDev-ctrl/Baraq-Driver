import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/model/model_finsh_trips.dart';
 
abstract class GetFinishedTripsRepo {
  Future<Either<Failure, List<FinishedTripModel>>> getFinishedTrips();
}