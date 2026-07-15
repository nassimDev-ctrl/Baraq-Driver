import 'package:flutter_bloc/flutter_bloc.dart';


import '../../repo/current_trip_repo/repo.dart';
import 'cubit_state.dart';

class GetStartedTripsCubit extends Cubit<GetStartedTripsState> {
  final GetStartedTripsRepository getStartedTripsRepository;

  GetStartedTripsCubit(this.getStartedTripsRepository)
      : super(GetStartedTripsInitial());

  Future<void> fetchStartedTrips() async {
    emit(GetStartedTripsLoading());

    final result = await getStartedTripsRepository.getStartedTrips();

    result.fold(
          (failure) => emit(GetStartedTripsFailure(failure.errMessage)),
          (trips) => emit(GetStartedTripsSuccess(trips)),
    );
  }
}