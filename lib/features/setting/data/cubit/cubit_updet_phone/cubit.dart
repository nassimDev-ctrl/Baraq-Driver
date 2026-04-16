import 'package:drever_warr/features/setting/data/cubit/cubit_updet_phone/cubit_stat.dart';
import 'package:drever_warr/features/setting/data/repo/repo_updet_phone.dart/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
   
 
class UpdateMobileCubit extends Cubit<UpdateMobileState> {
  final RepoUpdateMobile repo;
  UpdateMobileCubit(this.repo) : super(UpdateMobileInitial());

   
  Future<void> confirmUserPassword(String password) async {
    emit(UpdateMobileLoading());
    var result = await repo.confirmPassword(password);

    result.fold(
      (failure) => emit(UpdateMobileFailure(failure.errMassage)),
      (success) => emit(ConfirmPasswordSuccess()),
    );
  }

  
  Future<void> changeMobilePhone(String newMobile,String code) async {
    emit(UpdateMobileLoading());
    var result = await repo.updateMobilePhone(newMobile,code);

    result.fold(
      (failure) => emit(UpdateMobileFailure(failure.errMassage)),
      (message) => emit(UpdateMobilePhoneSuccess(message)),
    );
  }
}