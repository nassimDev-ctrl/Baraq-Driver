
abstract class UpdateLanguageState {}

class UpdateLanguageInitial extends UpdateLanguageState {}
class UpdateLanguageLoading extends UpdateLanguageState {}
class UpdateLanguageSuccess extends UpdateLanguageState {
  final String message;
  UpdateLanguageSuccess(this.message);
}
class UpdateLanguageFailure extends UpdateLanguageState {
  final String errMessage;
  UpdateLanguageFailure(this.errMessage);
}