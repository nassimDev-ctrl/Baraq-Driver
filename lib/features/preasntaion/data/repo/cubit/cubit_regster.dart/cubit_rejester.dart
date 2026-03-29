// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:warr2/features/Auth/preasntaion/data/repo/cubit/cubit_regster.dart/cubit_regster_state.dart';
// import 'package:warr2/features/Auth/preasntaion/data/repo/repo.dart';
  

// class RegisterCubit extends Cubit<RegisterState> {
//   final RepoRegister repo;

//   RegisterCubit(this.repo) : super(RegisterInitial());

//   // المتحكمات للحقول المطلوبة في الـ JSON
//   final firstName = TextEditingController();
//   final lastName = TextEditingController();
//   final mobilePhone = TextEditingController();
//   final governorate = TextEditingController();
//   final gender = TextEditingController();
//   final emergencyNumber = TextEditingController();
//   final password = TextEditingController();

//   Future<void> registerUser({required String otp}) async {
//     emit(RegisterLoading());

//     final Map<String, dynamic> userData = {
//       "firstName": firstName.text,
//       "lastName": lastName.text.isEmpty ? "ككككك" : lastName.text,
//       "mobilePhone":
//           "963${mobilePhone.text}", // تأكد من التنسيق (0 أو 963) حسب تجاربك السابقة
//       "governorate": "696df8dfd5776d96bddfa2b6",
//       "gender": gender.text.isEmpty ? "male" : gender.text,
//       "userType": "client",
//       "emergencyNumber": "963${emergencyNumber.text}",
//       "password": password.text,
//       "code": otp, // إضافة الكود الذي أدخله المستخدم هنا
//     };

//     var result = await repo.register(userData: userData);

//     result.fold(
//       (failure) => emit(RegisterFailure(failure.errMassage)),
//       (success) => emit(RegisterSuccess(success)),
//     );
//   }
// }
