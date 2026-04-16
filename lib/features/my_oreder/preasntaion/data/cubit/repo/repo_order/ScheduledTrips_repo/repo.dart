import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/model/ScheduledTrips.dart';

abstract class RepoScheduledTrips {
  Future<Either<Failur, List<ScheduledTripModel>>> fetchScheduledTrips();
}