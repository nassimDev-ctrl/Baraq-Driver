 
 
 
 
import 'package:drever_warr/features/preasntaion/data/repo/model/model_governorates.dart';

abstract class GovernoratesState {}

class GovernoratesInitial extends GovernoratesState {}

class GovernoratesLoading extends GovernoratesState {}

class GovernoratesSuccess extends GovernoratesState {
  final List<GovernorateModel> governorates;
  GovernoratesSuccess(this.governorates);
}

class GovernoratesFailure extends GovernoratesState {
  final String errMessage;
  GovernoratesFailure(this.errMessage);
}