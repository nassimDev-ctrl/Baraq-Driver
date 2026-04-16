import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_category/cubit_stat.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_category/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
class CarCategoryCubit extends Cubit<CarCategoryState> {
  final RepoCarCategory repo;

  CarCategoryCubit(this.repo) : super(CarCategoryInitial());

  Future<void> getCarCategories() async {
    emit(CarCategoryLoading());

    var result = await repo.fetchCarCategories();

    result.fold(
      (failure) => emit(CarCategoryFailure(failure.errMassage)),
      (categories) => emit(CarCategorySuccess(categories)),
    );
  }
}