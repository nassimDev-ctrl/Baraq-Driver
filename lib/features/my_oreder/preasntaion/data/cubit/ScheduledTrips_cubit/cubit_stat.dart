import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/model/ScheduledTrips.dart';

abstract class ScheduledTripsState {}

class ScheduledTripsInitial extends ScheduledTripsState {}
class ScheduledTripsLoading extends ScheduledTripsState {}
class ScheduledTripsSuccess extends ScheduledTripsState {
  final List<ScheduledTripModel> trips;
  ScheduledTripsSuccess(this.trips);
}
class ScheduledTripsFailure extends ScheduledTripsState {
  final String errMessage;
  ScheduledTripsFailure(this.errMessage);
}