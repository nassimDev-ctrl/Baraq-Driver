import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';

import '../../cubit/model/accsept_model.dart';

abstract class GetStartedTripsRepository {
  Future<Either<Failure, List<ActiveTripModel>>> getStartedTrips();
}