import 'package:drever_warr/features/setting/data/cubit/cubit_edit_passwrd/cubit_stat.dart';
import 'package:drever_warr/features/setting/data/repo/repo_edit_passowrd/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
  
class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordRepo _changePasswordRepo;

  ChangePasswordCubit(this._changePasswordRepo) : super(ChangePasswordInitial());

  Future<void> changePassword(String newPassword) async {
    emit(ChangePasswordLoading());

    var result = await _changePasswordRepo.changePassword(newPassword: newPassword);

    result.fold(
      (failure) => emit(ChangePasswordFailure(failure.errMassage)),
      (success) => emit(ChangePasswordSuccess(success)),
    );
  }
}