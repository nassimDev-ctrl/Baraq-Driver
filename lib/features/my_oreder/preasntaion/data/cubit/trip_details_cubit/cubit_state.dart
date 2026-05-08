
import '../../models/trip_response_model.dart';

abstract class TripDetailsState {}

class TripDetailsInitial extends TripDetailsState {}

class TripDetailsLoading extends TripDetailsState {}

class TripDetailsSuccess extends TripDetailsState {
  final TripResponseModel tripData;
  TripDetailsSuccess(this.tripData);
}

class TripDetailsFailure extends TripDetailsState {
  final String errMessage;
  TripDetailsFailure(this.errMessage);
}

class TripStatusCheckSuccess extends TripDetailsState {
  final bool isClientConfirmed;
  TripStatusCheckSuccess(this.isClientConfirmed);
}