abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final dynamic data;
  RegisterSuccess(this.data);
}

class RegisterFailure extends RegisterState {
  final String errMessage;
  RegisterFailure(this.errMessage);
}