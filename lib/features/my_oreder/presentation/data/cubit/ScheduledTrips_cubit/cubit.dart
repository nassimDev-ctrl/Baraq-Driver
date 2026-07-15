import 'package:drever_warr/features/my_oreder/presentation/data/cubit/ScheduledTrips_cubit/cubit_stat.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/repo/repo_order/ScheduledTrips_repo/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduledTripsCubit extends Cubit<ScheduledTripsState> {
  final RepoScheduledTrips _repo;

  ScheduledTripsCubit(this._repo) : super(ScheduledTripsInitial());

  Future<void> getScheduledTrips() async {
    emit(ScheduledTripsLoading());
    var result = await _repo.fetchScheduledTrips();

    result.fold(
      (failure) => emit(ScheduledTripsFailure(failure. errMessage)),
      (trips) => emit(ScheduledTripsSuccess(trips)),
    );
  }
}