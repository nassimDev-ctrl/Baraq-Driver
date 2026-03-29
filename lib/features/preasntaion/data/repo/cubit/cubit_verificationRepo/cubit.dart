// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:warr2/features/Auth/preasntaion/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
//  import 'package:warr2/features/Auth/preasntaion/data/repo/repo/repo_verificationRepo/repo.dart';
 
// class VerificationCubit extends Cubit<VerificationState> {
//   final VerificationRepo _verificationRepo;

//   VerificationCubit(this._verificationRepo) : super(VerificationInitial());

//   // 1. وظيفة طلب إرسال الكود
//   Future<void> sendVerificationCode({
//     required String mobilePhone,
//     required String typeOfUse,
//   }) async {
//     emit(VerificationLoading());
//     print("⏳ [CUBIT]: Sending Verification Code to $mobilePhone...");

//     var result = await _verificationRepo.createVerificationCode(
//       mobilePhone: mobilePhone,
//       typeOfUse: typeOfUse,
//     );

//     result.fold(
//       (failure) {
//         print("📢 [CUBIT ERROR]: ${failure.errMassage}");
//         emit(VerificationFailure(failure.errMassage));
//       },
//       (success) {
//         print("📢 [CUBIT SUCCESS]: OTP Sent Successfully!");
//         emit(CreateVerificationCodeSuccess(success));
//       },
//     );
//   }

//   // 2. وظيفة التحقق من الكود المدخل (Verify)
//   Future<void> verifyCode({
//     required String mobilePhone,
//     required String typeOfUse,
//     required String code,
//   }) async {
//     emit(VerificationLoading());
//     print("⏳ [CUBIT]: Verifying Code $code for $mobilePhone...");

//     var result = await _verificationRepo.verifyMobileNumber(
//       mobilePhone: mobilePhone,
//       typeOfUse: typeOfUse,
//       code: code,
//     );

//     result.fold(
//       (failure) {
//         print("📢 [CUBIT ERROR]: ${failure.errMassage}");
//         emit(VerificationFailure(failure.errMassage));
//       },
//       (success) {
//         print("📢 [CUBIT SUCCESS]: Phone Verified!");
//         emit(VerifyMobileNumberSuccess(success));
//       },
//     );
//   }
// }
