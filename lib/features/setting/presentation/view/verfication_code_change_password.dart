import 'package:drever_warr/core/widgets/auth/otp_verification_scaffold.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
import 'package:drever_warr/features/setting/presentation/view/new_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';

class VerificationCodeforgetpassword2 extends StatefulWidget {
  final String mobilePhone;
  const VerificationCodeforgetpassword2({super.key, required this.mobilePhone});

  @override
  State<VerificationCodeforgetpassword2> createState() =>
      _VerificationCodeforgetpassword2State();
}

class _VerificationCodeforgetpassword2State
    extends State<VerificationCodeforgetpassword2> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerificationCubit, VerificationState>(
      listener: (context, state) {
        if (state is VerifyMobileNumberSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  NewPassword(mobilePhone1: widget.mobilePhone),
            ),
          );
        } else if (state is VerificationFailure) {
          AppSnackBar.error(context, state.errMessage);
        }
      },
      builder: (context, state) {
        return OtpVerificationScaffold(
          phone: widget.mobilePhone,
          isLoading: state is VerificationLoading,
          verifyLabelKey: 'verify_button',
          onResend: () {
            var formattedPhone = widget.mobilePhone;
            if (formattedPhone.startsWith('0')) {
              formattedPhone = formattedPhone.substring(1);
            }
            context.read<VerificationCubit>().sendVerificationCode(
                  mobilePhone: '963$formattedPhone',
                  typeOfUse: 'reset-password',
                );
          },
          onVerify: (otp) {
            context.read<VerificationCubit>().verifyCode(
                  mobilePhone: '963${widget.mobilePhone}',
                  typeOfUse: 'reset-password',
                  code: otp,
                );
          },
        );
      },
    );
  }
}
