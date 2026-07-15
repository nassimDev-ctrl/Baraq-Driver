 import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_car_all_filld/cubit_stat.dart';
 import 'package:drever_warr/features/presentation/data/repo/repo/repo_car_all_filld/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarAllFilldCubit extends Cubit<CarAllFilldState> {
  final CarAllFilldRepo carAllFilldRepo;

  CarAllFilldCubit(this.carAllFilldRepo) : super(CarAllFilldInitial());

  Future<void> submitCarAllFilldDetails({
    required String carName,
    required String categoryId,
    required String plateNumber,
    required String yearMade,
    required String carImagePath,
    required String plateImagePath,
  }) async {
    emit(CarAllFilldLoading());

    final Map<String, dynamic> carData = {
      "carName": carName,
      "category": categoryId,
      "carPlateNumber": plateNumber,
      "carYearMade": yearMade,
      "car_image": carImagePath,
      "car_plate_image": plateImagePath,
    };

    var result = await carAllFilldRepo.completeCarAllFilldInfo(carData: carData);

    result.fold(
      (failure) => emit(CarAllFilldFailure(failure.errMessage)),
      (success) => emit(CarAllFilldSuccess(success)),
    );
  }
}