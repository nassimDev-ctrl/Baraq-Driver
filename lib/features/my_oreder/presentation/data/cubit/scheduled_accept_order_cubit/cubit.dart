
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/accsept_model.dart';
import '../repo/scheduled_accept_order_repo/repo.dart';
import 'cubit_state.dart';

class ScheduledAcceptTripCubit extends Cubit<ScheduledAcceptTripState> {
  final ScheduledAcceptOrderRepo _repo;

  ScheduledAcceptTripCubit(this._repo) : super(ScheduledAcceptTripInitial());

  Future<void> acceptScheduledTrip({required ActiveTripModel trip}) async {
    if (state is ScheduledAcceptTripLoading) return;

    emit(ScheduledAcceptTripLoading(trip.id));

    try {
      final result = await _repo.acceptScheduledTrip(tripId: trip.id);

      if (isClosed) return;

      result.fold(
            (failure) => emit(ScheduledAcceptTripFailure(failure.errMessage)),
            (_)        => emit(ScheduledAcceptTripSuccess(trip)),
      );
    } catch (e) {
      if (!isClosed) emit(ScheduledAcceptTripFailure(e.toString()));
    }
  }
}