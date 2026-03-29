abstract class VerificationState {}

class VerificationInitial extends VerificationState {}

class VerificationLoading extends VerificationState {}

// حالة نجاح إرسال الكود
class CreateVerificationCodeSuccess extends VerificationState {
  final dynamic response;
  CreateVerificationCodeSuccess(this.response);
}

// حالة نجاح التحقق من الكود (المرحلة النهائية)
class VerifyMobileNumberSuccess extends VerificationState {
  final dynamic response;
  VerifyMobileNumberSuccess(this.response);
}

class VerificationFailure extends VerificationState {
  final String errMessage;
  VerificationFailure(this.errMessage);
}