import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drever_warr/core/service/failear.dart';

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