// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:warr2/features/Auth/preasntaion/data/repo/cubit/cubit_login/cubit_state.dart';
// import 'package:warr2/features/Auth/preasntaion/data/repo/repo/repo_login/repo.dart';
   
// class LoginCubit extends Cubit<LoginState> {
//   final RepoLogin repo;

//   LoginCubit(this.repo) : super(LoginInitial());

//   final mobilePhoneController = TextEditingController();
//   final passwordController = TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();

//   Future<void> loginUser() async {
//     if (!formKey.currentState!.validate()) return;

//     emit(LoginLoading());

//     // نرسل الرقم مع المفتاح الدولي 963 كما فعلنا بالتسجيل
//     var result = await repo.login(
//       mobilePhone: "963${mobilePhoneController.text}",
//       password: passwordController.text,
//     );

//     result.fold(
//       (failure) => emit(LoginFailure(failure.errMassage)),
//       (success) => emit(LoginSuccess(success)),
//     );
//   }

//   @override
//   Future<void> close() {
//     mobilePhoneController.dispose();
//     passwordController.dispose();
//     return super.close();
//   }
// }