abstract class UploadIdState {}

class UploadIdInitial extends UploadIdState {}

class UploadIdLoading extends UploadIdState {}

class UploadIdSuccess extends UploadIdState {
  final dynamic data;
  UploadIdSuccess(this.data);
}

class UploadIdFailure extends UploadIdState {
  final String errMessage;
  UploadIdFailure(this.errMessage);
}