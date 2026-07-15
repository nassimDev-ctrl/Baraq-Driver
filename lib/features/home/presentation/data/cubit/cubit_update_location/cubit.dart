import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/update_location/repo.dart';
import 'cubit_state.dart';

class DriverLocationCubit extends Cubit<DriverLocationState> {
  final DriverLocationRepository driverLocationRepository;

  DriverLocationCubit(this.driverLocationRepository)
      : super(DriverLocationInitial());

  Future<void> updateDriverLocation({
    required double longitude,
    required double latitude,
    required String address,
  }) async {
    emit(DriverLocationLoading());

    final result = await driverLocationRepository.updateDriverLocation(
      longitude: longitude,
      latitude: latitude,
      address: address,
    );

    result.fold(
          (failure) => emit(DriverLocationFailure(failure.errMessage)),
          (response) => emit(DriverLocationSuccess(response)),
    );
  }
  Future<void> updateDriverLocationForTrip({
    required String tripId,
    required double longitude,
    required double latitude,
    required String address,
  }) async {
    emit(DriverLocationLoading());

    final result = await driverLocationRepository.updateDriverLocationForTrip(
      tripId: tripId,
      longitude: longitude,
      latitude: latitude,
      address: address,
    );

    result.fold(
          (failure) => emit(DriverLocationFailure(failure.errMessage)),
          (response) => emit(DriverLocationSuccess(response)),
    );
  }
  Future<void> updateEmergencyLocationForTrip({
    required String tripId,
    required double longitude,
    required double latitude,
    required String address,
  }) async {
    emit(DriverLocationLoading());

    final result = await driverLocationRepository.updateEmergencyLocationForTrip(
      tripId: tripId,
      longitude: longitude,
      latitude: latitude,
      address: address,
    );

    result.fold(
          (failure) => emit(DriverLocationFailure(failure.errMessage)),
          (response) => emit(DriverLocationSuccess(response)),
    );
  }
}