// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:warr2/features/Auth/preasntaion/data/repo/cubit/cubit_governorates/cubit_state.dart';
// import 'package:warr2/features/Auth/preasntaion/data/repo/repo/repo_governorates/repo.dart';
 
 

// class GovernoratesCubit extends Cubit<GovernoratesState> {
//   final RepoGovernorates repo;

//   GovernoratesCubit(this.repo) : super(GovernoratesInitial());

//   Future<void> getGovernorates() async {
//     emit(GovernoratesLoading());

//     var result = await repo.fetchGovernorates();

//     result.fold(
//       (failure) => emit(GovernoratesFailure(failure.errMassage)),
//       (governorates) => emit(GovernoratesSuccess(governorates)),
//     );
//   }
// }