
import '../model/accsept_model.dart';

abstract class GetStartedTripsState {}

class GetStartedTripsInitial extends GetStartedTripsState {}

class GetStartedTripsLoading extends GetStartedTripsState {}

class GetStartedTripsSuccess extends GetStartedTripsState {
  final List<ActiveTripModel> trips;
  GetStartedTripsSuccess(this.trips);
}

class GetStartedTripsFailure extends GetStartedTripsState {
  final String errMessage;
  GetStartedTripsFailure(this.errMessage);
}