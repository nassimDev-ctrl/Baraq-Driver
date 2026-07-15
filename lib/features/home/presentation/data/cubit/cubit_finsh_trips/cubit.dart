 import 'package:drever_warr/features/home/presentation/data/cubit/cubit_finsh_trips/cubit_stat.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/repo/finsh_trips_repo/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
class GetFinishedTripsCubit extends Cubit<GetFinishedTripsState> {
  final GetFinishedTripsRepo getFinishedTripsRepo;

  GetFinishedTripsCubit(this.getFinishedTripsRepo) : super(GetFinishedTripsInitial());

  Future<void> fetchFinishedTrips() async {
    emit(GetFinishedTripsLoading());
    var result = await getFinishedTripsRepo.getFinishedTrips();

    result.fold(
      (failure) => emit(GetFinishedTripsFailure(failure.errMessage)),
      (trips) => emit(GetFinishedTripsSuccess(trips)),
    );
  }
}