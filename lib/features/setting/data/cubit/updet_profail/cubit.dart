 

import 'package:drever_warr/features/setting/data/cubit/updet_profail/cubit_stat.dart';
import 'package:drever_warr/features/setting/data/repo/repo_updet_profail/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  final UpdateProfileRepo _repo;
  UpdateProfileCubit(this._repo) : super(UpdateProfileInitial());

  Future<void> updateUserData({
    required String firstName,
    required String lastName,
    required String governorate,
    String? imagePath, 
  }) async {
    emit(UpdateProfileLoading());

    var result = await _repo.updateProfile(
      firstName: firstName,
      lastName: lastName,
      governorate: governorate,
      imagePath: imagePath,  
    );

    result.fold(
      (failure) => emit(UpdateProfileFailure(failure.errMassage)),
      (successMsg) => emit(UpdateProfileSuccess(successMsg)),
    );
  }
}