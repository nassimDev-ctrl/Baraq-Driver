import 'package:drever_warr/core/widgets/auth/otp_verification_scaffold.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
import 'package:drever_warr/features/presentation/view/conferm_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';

class VerificationCodeforgetpassword extends StatefulWidget {
  final String mobilePhone;
  const VerificationCodeforgetpassword({super.key, required this.mobilePhone});

  @override
  State<VerificationCodeforgetpassword> createState() =>
      _VerificationCodeforgetpasswordState();
}

class _VerificationCodeforgetpasswordState
    extends State<VerificationCodeforgetpassword> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerificationCubit, VerificationState>(
      listener: (context, state) {
        if (state is VerifyMobileNumberSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ConfermPassword(mobilePhone1: widget.mobilePhone),
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
            context.read<VerificationCubit>().sendVerificationCode(
                  mobilePhone: widget.mobilePhone,
                  typeOfUse: 'reset-password',
                );
          },
          onVerify: (otp) {
            context.read<VerificationCubit>().verifyCode(
                  mobilePhone: widget.mobilePhone,
                  typeOfUse: 'reset-password',
                  code: otp,
                );
          },
        );
      },
    );
  }
}
