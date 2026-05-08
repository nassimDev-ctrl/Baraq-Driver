import 'package:drever_warr/features/preasntaion/data/repo/cubit/cubit_login/cubit_state.dart';
import 'package:drever_warr/features/preasntaion/data/repo/repo/repo_login/repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utiles/normlize_number.dart';

class LoginCubit extends Cubit<LoginState> {
  final RepoLogin repo;

  LoginCubit(this.repo) : super(LoginInitial());

  final mobilePhoneController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;

  Future<void> loginUser() async {
    if (_isSubmitting) return;

    final formState = formKey.currentState;
    if (formState == null) return;

    if (!formState.validate()) return;

    _isSubmitting = true;
    emit(LoginLoading());

    try {
      final formattedPhone = normalizePhone(mobilePhoneController.text.trim());
      final phoneToSend = _buildPhoneWithCountryCode(formattedPhone);

      final result = await repo.login(
        mobilePhone: phoneToSend,
        password: passwordController.text,
      );

      if (isClosed) return;

      result.fold(
            (failure) => emit(LoginFailure(failure.errMassage)),
            (success) => emit(LoginSuccess(success)),
      );
    } catch (e) {
      if (!isClosed) {
        emit(LoginFailure(e.toString()));
      }
    } finally {
      _isSubmitting = false;
    }
  }

  String _buildPhoneWithCountryCode(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\s+'), '');

    if (cleaned.startsWith('963')) {
      return cleaned;
    }

    if (cleaned.startsWith('0')) {
      return '963${cleaned.substring(1)}';
    }

    return '963$cleaned';
  }

  @override
  Future<void> close() {
    mobilePhoneController.dispose();
    passwordController.dispose();
    return super.close();
  }
}