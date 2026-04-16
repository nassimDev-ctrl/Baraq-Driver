 
import 'package:drever_warr/features/setting/data/model/model_profail.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final ProfileModel data; 
  ProfileSuccess(this.data);
}

class ProfileFailure extends ProfileState {
  final String errMessage;
  ProfileFailure(this.errMessage);
}