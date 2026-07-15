import 'package:dartz/dartz.dart';
import 'package:drever_warr/core/service/failure.dart';
 import 'package:drever_warr/features/presentation/data/repo/model/model_category.dart';

abstract class RepoCarCategory {
  Future<Either<Failure, List<CarCategoryModel>>> fetchCarCategories();
}