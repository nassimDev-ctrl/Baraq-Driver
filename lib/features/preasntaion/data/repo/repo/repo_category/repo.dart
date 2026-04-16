import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failear.dart';
 import 'package:drever_warr/features/preasntaion/data/repo/model/model_category.dart';

abstract class RepoCarCategory {
  Future<Either<Failur, List<CarCategoryModel>>> fetchCarCategories();
}