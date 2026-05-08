import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/model/accsept_model.dart';


abstract class AcceptTripState {}

class AcceptTripInitial extends AcceptTripState {}

class AcceptTripLoading extends AcceptTripState {
  final String tripId;
  AcceptTripLoading(this.tripId);
}

class AcceptTripSuccess extends AcceptTripState {
  final ActiveTripModel trip;
  AcceptTripSuccess(this.trip);
}

class AcceptTripFailure extends AcceptTripState {
  final String errMessage;
  AcceptTripFailure(this.errMessage);
}
