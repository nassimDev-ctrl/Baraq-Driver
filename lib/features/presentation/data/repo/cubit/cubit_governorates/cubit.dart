 
 
 

import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_governorates/cubit_state.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_governorates/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GovernoratesCubit extends Cubit<GovernoratesState> {
  final RepoGovernorates repo;

  GovernoratesCubit(this.repo) : super(GovernoratesInitial());

  Future<void> getGovernorates() async {
    emit(GovernoratesLoading());

    var result = await repo.fetchGovernorates();

    result.fold(
      (failure) => emit(GovernoratesFailure(failure.errMessage)),
      (governorates) => emit(GovernoratesSuccess(governorates)),
    );
  }
}