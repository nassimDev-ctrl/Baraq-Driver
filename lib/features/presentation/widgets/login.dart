import 'package:drever_warr/core/cash/preferences_service.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/di/home_session.dart';
import 'package:drever_warr/core/service/notification_service.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_login/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_login/cubit_state.dart';
import 'package:drever_warr/features/presentation/view/forget_password_login.dart';
import 'package:drever_warr/features/presentation/view/location_drever.dart';
import 'package:drever_warr/features/presentation/view/waiting_review_screen.dart';
import 'package:drever_warr/features/presentation/widgets/login/login_form_card.dart';
import 'package:drever_warr/features/presentation/widgets/login/login_header.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  void _showError(BuildContext context, String message) {
    AppSnackBar.error(context, message);
  }

  Future<void> _onLoginSuccess(
    BuildContext context,
    LoginSuccess state,
  ) async {
    final cubit = context.read<LoginCubit>();
    await NotificationService.instance.syncToken();

    final dataUser = state.data['data']['user'];
    cubit.mobilePhoneController.clear();
    cubit.passwordController.clear();

    final profile = dataUser['profile'];
    final status =
        profile?['status']?.toString() ?? dataUser['status']?.toString();
    if (status != null && status.isNotEmpty) {
      await CacheManager.saveData(CacheManager.statusKey, status);
    }

    final authUser = profile?['authUser']?.toString() ?? '';
    if (authUser.isNotEmpty) {
      await CacheManager.saveData(CacheManager.authUserKey, authUser);
    }

    if (!context.mounted) return;

    if (status == 'active' || status == 'change-category') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeSession()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => WaitingReviewScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (previous, current) =>
          current is LoginSuccess || current is LoginFailure,
      listener: (context, state) async {
        if (state is LoginSuccess) {
          await _onLoginSuccess(context, state);
        } else if (state is LoginFailure) {
          _showError(context, state.errMessage);
        }
      },
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();
        final isLoading = state is LoginLoading;

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.translucent,
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(
                  bottom: bottomInset + AppSpacing.lg.h,
                ),
                child: Column(
                  children: [
                    const LoginHeader(),
                    Transform.translate(
                      offset: Offset(0, -AuthUiConstants.cardOverlap.h),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.md.w,
                        ),
                        child: LoginFormCard(
                          formKey: cubit.formKey,
                          phoneController: cubit.mobilePhoneController,
                          passwordController: cubit.passwordController,
                          isLoading: isLoading,
                          onLogin: () {
                            FocusScope.of(context).unfocus();
                            final form = cubit.formKey.currentState;
                            if (form == null || !form.validate()) return;
                            cubit.loginUser();
                          },
                          onForgotPassword: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ForgetPasswordLogin(),
                              ),
                            );
                          },
                          onCreateAccount: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddLocation(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
