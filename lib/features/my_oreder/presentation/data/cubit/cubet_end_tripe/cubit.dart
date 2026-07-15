import 'package:drever_warr/features/my_oreder/presentation/data/cubit/cubet_end_tripe/cubit_stat.dart';
import 'package:drever_warr/features/my_oreder/presentation/data/cubit/repo/repo_end_tripe/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EndTripCubit extends Cubit<EndTripState> {
  final EndTripRepository endTripRepository;

  EndTripCubit(this.endTripRepository) : super(EndTripInitial());

  Future<void> completeTrip({required String tripId}) async {
    emit(EndTripLoading());
    
    var result = await endTripRepository.completeTrip(tripId: tripId);

    result.fold(
      (failure) => emit(EndTripFailure(failure. errMessage)),
      (successMessage) => emit(EndTripSuccess(successMessage)),
    );
  }
}