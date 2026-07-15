import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/trip_details_repo/repo.dart';
import 'cubit_state.dart';

class TripDetailsCubit extends Cubit<TripDetailsState> {
  final TripDetailsRepository tripDetailsRepository;

  TripDetailsCubit(this.tripDetailsRepository) : super(TripDetailsInitial());

  Future<void> fetchTripDetails({required String tripId}) async {
    emit(TripDetailsLoading());

    final result = await tripDetailsRepository.getTripDetails(tripId: tripId);

    result.fold(
          (failure) => emit(TripDetailsFailure(failure.errMessage)),
          (tripData) => emit(TripDetailsSuccess(tripData)),
    );
  }

  Future<void> checkIfClientConfirmed({required String tripId}) async {
    emit(TripDetailsLoading());

    final result = await tripDetailsRepository.isClientConfirmed(tripId: tripId);

    result.fold(
          (failure) => emit(TripDetailsFailure(failure.errMessage)),
          (isConfirmed) => emit(TripStatusCheckSuccess(isConfirmed)),
    );
  }
}