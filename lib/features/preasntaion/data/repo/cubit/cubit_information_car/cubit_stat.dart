abstract class CarInfoState {}

class CarInfoInitial extends CarInfoState {}

class CarInfoLoading extends CarInfoState {}

class CarInfoSuccess extends CarInfoState {
  final dynamic data;
  CarInfoSuccess(this.data);
}

class CarInfoFailure extends CarInfoState {
  final String errMessage;
  CarInfoFailure(this.errMessage);
}