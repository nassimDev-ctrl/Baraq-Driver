abstract class EndTripState {}

class EndTripInitial extends EndTripState {}

class EndTripLoading extends EndTripState {}

class EndTripSuccess extends EndTripState {
  final String message;
  EndTripSuccess(this.message);
}

class EndTripFailure extends EndTripState {
  final String errMessage;
  EndTripFailure(this.errMessage);
}