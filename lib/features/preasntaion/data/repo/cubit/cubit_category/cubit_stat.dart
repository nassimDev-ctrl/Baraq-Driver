 import 'package:drever_warr/features/preasntaion/data/repo/model/model_category.dart';

abstract class CarCategoryState {}

class CarCategoryInitial extends CarCategoryState {}
class CarCategoryLoading extends CarCategoryState {}

class CarCategorySuccess extends CarCategoryState {
  final List<CarCategoryModel> categories;
  CarCategorySuccess(this.categories);
}

class CarCategoryFailure extends CarCategoryState {
  final String errMessage;
  CarCategoryFailure(this.errMessage);
}