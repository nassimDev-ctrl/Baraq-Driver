import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_forget_passwrde/cubit_state.dart';
import 'package:drever_warr/features/presentation/data/repo/repo/repo_forget_passwrd/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
 
 
class ConfirmPasswordCubit extends Cubit<ConfirmPasswordState> {
  final ConfirmPasswordRepo _repo;
  ConfirmPasswordCubit(this._repo) : super(ConfirmPasswordInitial());

  Future<void> confirmNewPassword({required String password,required String mobilphone}) async {
    emit(ConfirmPasswordLoading());

    var result = await _repo.confirmPassword(password: password,mobilphone:mobilphone );

    result.fold(
      (failure) => emit(ConfirmPasswordFailure(failure.errMessage)),
      (success) => emit(ConfirmPasswordSuccess(success)),
    );
  }
}