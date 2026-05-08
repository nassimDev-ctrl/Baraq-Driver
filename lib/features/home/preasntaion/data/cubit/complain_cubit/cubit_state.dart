abstract class AddComplainState {}

class AddComplainInitial extends AddComplainState {}

class AddComplainLoading extends AddComplainState {}

class AddComplainSuccess extends AddComplainState {
  final String message;
  AddComplainSuccess(this.message);
}

class AddComplainFailure extends AddComplainState {
  final String errMessage;
  AddComplainFailure(this.errMessage);
}