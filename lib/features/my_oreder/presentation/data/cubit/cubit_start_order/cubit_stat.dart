abstract class StartTripState {}

class StartTripInitial extends StartTripState {}

class StartTripLoading extends StartTripState {}

class StartTripSuccess extends StartTripState {
  final String message;
  StartTripSuccess(this.message);
}

class StartTripFailure extends StartTripState {
  final String errMessage;
  StartTripFailure(this.errMessage);
}