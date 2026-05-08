import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repo/trip_note_repo/repo.dart';
import 'cubit_state.dart';

class TripNoteCubit extends Cubit<TripNoteState> {
  final TripNoteRepository tripNoteRepository;

  TripNoteCubit(this.tripNoteRepository) : super(TripNoteInitial());

  Future<void> fetchTripNote({required String tripId}) async {
    emit(TripNoteLoading());

    final result = await tripNoteRepository.fetchTripNote(tripId: tripId);

    result.fold(
          (failure) => emit(TripNoteFailure(failure.errMassage)),
          (note) => emit(TripNoteSuccess(note)),
    );
  }
}