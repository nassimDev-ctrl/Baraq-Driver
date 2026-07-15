 abstract class CarAllFilldState {}

class CarAllFilldInitial extends CarAllFilldState {}

class CarAllFilldLoading extends CarAllFilldState {}

class CarAllFilldSuccess extends CarAllFilldState {
  final dynamic data;
  CarAllFilldSuccess(this.data);
}

class CarAllFilldFailure extends CarAllFilldState {
  final String errMessage;
  CarAllFilldFailure(this.errMessage);
}