import 'package:drever_warr/core/widgets/auth/otp_verification_scaffold.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_regster.dart/cubit_regster_state.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_regster.dart/cubit_rejester.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/presentation/view/register_photo_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';

class VerificationCodeRegster extends StatefulWidget {
  const VerificationCodeRegster({super.key, required this.phone});
  final String phone;

  @override
  State<VerificationCodeRegster> createState() =>
      _VerificationCodeRegsterState();
}

class _VerificationCodeRegsterState extends State<VerificationCodeRegster> {
  @override
  Widget build(BuildContext context) {
    final registerCubit = context.read<RegisterCubit>();

    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const RegisterPhotoScreen(isUpdate: false),
            ),
          );
        } else if (state is RegisterFailure) {
          AppSnackBar.error(context, state.errMessage);
        }
      },
      builder: (context, state) {
        return OtpVerificationScaffold(
          phone: widget.phone,
          isLoading: state is RegisterLoading,
          verifyLabelKey: 'verify_button',
          onResend: () {
            context.read<VerificationCubit>().sendVerificationCode(
                  mobilePhone: '963${widget.phone}',
                  typeOfUse: 'activate-account',
                );
          },
          onVerify: (otp) => registerCubit.registerUser(otp: otp),
        );
      },
    );
  }
}
