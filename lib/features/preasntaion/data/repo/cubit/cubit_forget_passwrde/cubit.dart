// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:warr2/features/Auth/preasntaion/data/repo/cubit/cubit_forget_passwrde/cubit_state.dart';
// import 'package:warr2/features/Auth/preasntaion/data/repo/repo/repo_forget_passwrd/repo.dart';
 
 
 
// class ConfirmPasswordCubit extends Cubit<ConfirmPasswordState> {
//   final ConfirmPasswordRepo _repo;
//   ConfirmPasswordCubit(this._repo) : super(ConfirmPasswordInitial());

//   Future<void> confirmNewPassword({required String password,required String mobilphone}) async {
//     emit(ConfirmPasswordLoading());

//     var result = await _repo.confirmPassword(password: password,mobilphone:mobilphone );

//     result.fold(
//       (failure) => emit(ConfirmPasswordFailure(failure.errMassage)),
//       (success) => emit(ConfirmPasswordSuccess(success)),
//     );
//   }
// }