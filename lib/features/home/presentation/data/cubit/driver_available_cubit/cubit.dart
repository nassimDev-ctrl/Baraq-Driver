import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/driver_available_repo/repo.dart';
import 'cubit_state.dart';

class DriverStatusCubit extends Cubit<DriverStatusState> {
  final DriverStatusRepository driverStatusRepository;

  DriverStatusCubit(this.driverStatusRepository) : super(DriverStatusInitial());

  Future<void> fetchDriverAvailability() async {
    emit(DriverStatusLoading());

    final result = await driverStatusRepository.getDriverAvailability();

    result.fold(
          (failure) => emit(DriverStatusFailure(failure.errMessage)),
          (isAvailable) => emit(DriverStatusLoaded(isAvailable: isAvailable)),
    );
  }

  Future<void> toggleDriverAvailability() async {
    final currentState = state;

    if (currentState is! DriverStatusLoaded) return;

    final targetValue = !currentState.isAvailable;

    emit(DriverStatusLoaded(
      isAvailable: currentState.isAvailable,
      isUpdating: true,
    ));

    final result = await driverStatusRepository.setDriverAvailability(targetValue);

    result.fold(
          (failure) => emit(DriverStatusFailure(failure.errMessage)),
          (updatedValue) => emit(DriverStatusLoaded(isAvailable: updatedValue)),
    );
  }
}