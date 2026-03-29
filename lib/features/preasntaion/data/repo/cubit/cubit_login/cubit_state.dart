abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final dynamic data;
  LoginSuccess(this.data);
}

class LoginFailure extends LoginState {
  final String errMessage;
  LoginFailure(this.errMessage);
}