import 'package:drever_warr/core/cash/preferences_servis.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_profail/cubit_stat.dart';
import 'package:drever_warr/features/setting/data/repo/repo_profail/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
 
class ProfileCubit extends Cubit<ProfileState> {
  final RepoProfile repo;

  ProfileCubit(this.repo) : super(ProfileInitial());

  Future<void> getProfileData() async {
    emit(ProfileLoading());

    final result = await repo.getProfile();

    await result.fold(
      (failure) async {
        emit(ProfileFailure(failure.errMassage));
      },
      (success) async {
        final status = success.data?.status;
        if (status != null && status.trim().isNotEmpty) {
          await CacheManager.saveData(CacheManager.statusKey, status);
        }

        final authUserId = success.data?.authUser?.id;
        if (authUserId != null && authUserId.trim().isNotEmpty) {
          await CacheManager.saveData(CacheManager.authUserKey, authUserId);
        }

        emit(ProfileSuccess(success));
      },
    );
  }
}