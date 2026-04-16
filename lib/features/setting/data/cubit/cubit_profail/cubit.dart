import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit_stat.dart';
import 'package:drever_warr/features/setting/data/repo/repo_profail/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
 
class ProfileCubit extends Cubit<ProfileState> {
  final RepoProfile repo;

  ProfileCubit(this.repo) : super(ProfileInitial());

  Future<void> getProfileData() async {
    emit(ProfileLoading());

    var result = await repo.getProfile();

    result.fold(
      (failure) => emit(ProfileFailure(failure.errMassage)),
      (success) => emit(ProfileSuccess(success)),
    );
  }
}