import 'package:drever_warr/core/utiles/normlize_number.dart';
import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_verificationRepo/repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerificationCubit extends Cubit<VerificationState> {
  final VerificationRepo _verificationRepo;

  VerificationCubit(this._verificationRepo) : super(VerificationInitial());

   
  Future<void> sendVerificationCode({
    required String mobilePhone,
    required String typeOfUse,
  }) async {
    emit(VerificationLoading());
    print("⏳ [CUBIT]: Sending Verification Code to $mobilePhone...");

    var result = await _verificationRepo.createVerificationCode(
      mobilePhone: normalizePhone(mobilePhone),
      typeOfUse: typeOfUse,
    );

    result.fold(
      (failure) {
        print("📢 [CUBIT ERROR]: ${failure.errMassage}");
        emit(VerificationFailure(failure.errMassage));
      },
      (success) {
        print("📢 [CUBIT SUCCESS]: OTP Sent Successfully!");
        emit(CreateVerificationCodeSuccess(success));
      },
    );
  }

  
  Future<void> verifyCode({
    required String mobilePhone,
    required String typeOfUse,
    required String code,
  }) async {
    emit(VerificationLoading());
    print("⏳ [CUBIT]: Verifying Code $code for $mobilePhone...");

    var result = await _verificationRepo.verifyMobileNumber(
      mobilePhone: normalizePhone(mobilePhone),
      typeOfUse: typeOfUse,
      code: code,
    );

    result.fold(
      (failure) {
        print("📢 [CUBIT ERROR]: ${failure.errMassage}");
        emit(VerificationFailure(failure.errMassage));
      },
      (success) {
        print("📢 [CUBIT SUCCESS]: Phone Verified!");
        emit(VerifyMobileNumberSuccess(success));
      },
    );
  }
}
