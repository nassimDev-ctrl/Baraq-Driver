import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/cubit_start_order/cubit_stat.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/repo/repo_start_tripe/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StartTripCubit extends Cubit<StartTripState> {
  final TripRepository tripRepository;

  StartTripCubit(this.tripRepository) : super(StartTripInitial());

  Future<void> startTrip({required String tripId}) async {
    emit(StartTripLoading());
    var result = await tripRepository.startTrip(tripId: tripId);

    result.fold(
      (failure) => emit(StartTripFailure(failure. errMassage)),
      (successMessage) => emit(StartTripSuccess(successMessage)),
    );
  }
}