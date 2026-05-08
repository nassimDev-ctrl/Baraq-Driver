import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
import 'package:drever_warr/features/home/preasntaion/data/cubit/model/model_finsh_trips.dart';

import '../../cubit/model/accsept_model.dart';

abstract class GetStartedTripsRepository {
  Future<Either<Failur, List<ActiveTripModel>>> getStartedTrips();
}