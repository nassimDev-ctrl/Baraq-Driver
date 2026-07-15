abstract class UploadImageState {}

class UploadImageInitial extends UploadImageState {}

class UploadImageLoading extends UploadImageState {}

class UploadImageSuccess extends UploadImageState {
  final dynamic data;
  UploadImageSuccess(this.data);
}

class UploadImageFailure extends UploadImageState {
  final String errMessage;
  UploadImageFailure(this.errMessage);
}