import 'dart:io';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_information_car/cubit_stat.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_information_car/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
  
class CarInfoCubit extends Cubit<CarInfoState> {
  final RepoCarInfo repo;
  CarInfoCubit(this.repo) : super(CarInfoInitial());

   
  File? carImage;
  File? carPlateImage;

  
  Future<void> submitCarInfo({
    required String carName,
    
    required String category,
    required String carPlateNumber,
    required String carYearMade,
  }) async {
    if (carImage == null || carPlateImage == null) {
      emit(CarInfoFailure("يرجى اختيار جميع الصور المطلوبة"));
      return;
    }

    emit(CarInfoLoading());

    var result = await repo.completeCarInfo(
      carImage: carImage!,
      carPlateImage: carPlateImage!,
      carName: carName,
      category: category,
      carPlateNumber: carPlateNumber,
      carYearMade: carYearMade,
    );

    result.fold(
      (failure) => emit(CarInfoFailure(failure.errMassage)),
      (success) => emit(CarInfoSuccess(success)),
    );
  }
}