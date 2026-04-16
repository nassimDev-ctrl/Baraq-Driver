import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_login/cubit_state.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_login/repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
   
class LoginCubit extends Cubit<LoginState> {
  final RepoLogin repo;

  LoginCubit(this.repo) : super(LoginInitial());

  final mobilePhoneController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> loginUser() async {
    if (!formKey.currentState!.validate()) return;

    emit(LoginLoading());

   
    var result = await repo.login(
      mobilePhone: "963${mobilePhoneController.text}",
      password: passwordController.text,
    );

    result.fold(
      (failure) => emit(LoginFailure(failure.errMassage)),
      (success) => emit(LoginSuccess(success)),
    );
  }

  @override
  Future<void> close() {
    mobilePhoneController.dispose();
    passwordController.dispose();
    return super.close();
  }
}