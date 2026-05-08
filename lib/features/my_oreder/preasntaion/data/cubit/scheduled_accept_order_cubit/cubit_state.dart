import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/model/accsept_model.dart';

import '../model/ScheduledTrips.dart';

abstract class ScheduledAcceptTripState {}

class ScheduledAcceptTripInitial extends ScheduledAcceptTripState {}

class ScheduledAcceptTripLoading extends ScheduledAcceptTripState {
  final String tripId;
  ScheduledAcceptTripLoading(this.tripId);
}

class ScheduledAcceptTripSuccess extends ScheduledAcceptTripState {
  final ActiveTripModel trip;
  ScheduledAcceptTripSuccess(this.trip);
}

class ScheduledAcceptTripFailure extends ScheduledAcceptTripState {
  final String errMessage;
  ScheduledAcceptTripFailure(this.errMessage);
}