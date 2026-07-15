import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/model/scheduled_trips.dart';

abstract class RepoScheduledTrips {
  Future<Either<Failure, List<ScheduledTripModel>>> fetchScheduledTrips();
}