import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/accept_order_cubit/cubit_stat.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/model/accsept_model.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/repo/accept_order_repo/repo.dart';
 import 'package:flutter_bloc/flutter_bloc.dart';
 
class AcceptTripCubit extends Cubit<AcceptTripState> {
  final AcceptTripRepo _acceptTripRepo;

  AcceptTripCubit(this._acceptTripRepo) : super(AcceptTripInitial());

  
Future<void> acceptTrip({required ActiveTripModel trip}) async {
  emit(AcceptTripLoading());
  
  var result = await _acceptTripRepo.acceptTrip(tripId: trip.id);

  result.fold(
    (failure) => emit(AcceptTripFailure(failure. errMassage)),
    (successData) {
     
      emit(AcceptTripSuccess(trip)); 
    },
  );
}
}