import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/model/model_finsh_trips.dart';
 
abstract class GetFinishedTripsRepo {
  Future<Either<Failur, List<FinishedTripModel>>> getFinishedTrips();
}