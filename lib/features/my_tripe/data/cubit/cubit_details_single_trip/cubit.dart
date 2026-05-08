import 'package:drever_warr/features/home/preasntaion/data/cubit/model/model_finsh_trips.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/details_single_trip_repo/repo.dart';
import 'cubit_state.dart';

class SingleTripDetailsCubit extends Cubit<SingleTripDetailsState> {
  final SingleTripDetailsRepository tripDetailsRepository;

  SingleTripDetailsCubit(this.tripDetailsRepository) : super(SingleTripDetailsInitial());

  Future<void> getTripById({required String tripId}) async {
    emit(SingleTripDetailsLoading());

    final result = await tripDetailsRepository.getTripById(tripId: tripId);

    result.fold(
          (failure) => emit(SingleTripDetailsFailure(failure.errMassage)),
          (trip) => emit(SingleTripDetailsSuccess(trip)),
    );
  }
}