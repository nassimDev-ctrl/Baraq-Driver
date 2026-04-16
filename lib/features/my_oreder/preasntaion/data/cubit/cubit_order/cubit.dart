import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/cubit_order/cubit_stat.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/data/cubit/repo/repo_order/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
class SearchingTripsCubit extends Cubit<SearchingTripsState> {
  final RepoSearchingTrips repo;

  SearchingTripsCubit(this.repo) : super(SearchingTripsInitial());

  Future<void> getSearchingTrips() async {
    emit(SearchingTripsLoading());

    var result = await repo.fetchSearchingTrips();

    result.fold(
      (failure) => emit(SearchingTripsFailure(failure.errMassage)),
      (trips) => emit(SearchingTripsSuccess(trips)),
    );
  }
}