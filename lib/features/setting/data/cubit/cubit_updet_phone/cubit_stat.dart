abstract class UpdateMobileState {}

class UpdateMobileInitial extends UpdateMobileState {}
class UpdateMobileLoading extends UpdateMobileState {}

 
class ConfirmPasswordSuccess extends UpdateMobileState {}

 
class UpdateMobilePhoneSuccess extends UpdateMobileState {
  final String message;
  UpdateMobilePhoneSuccess(this.message);
}


class UpdateMobileFailure extends UpdateMobileState {
  final String errMessage;
  UpdateMobileFailure(this.errMessage);
}