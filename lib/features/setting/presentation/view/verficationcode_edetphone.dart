import 'package:drever_warr/core/widgets/auth/otp_verification_scaffold.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_updet_phone/cubit.dart';
import 'package:drever_warr/features/setting/data/cubit/cubit_updet_phone/cubit_stat.dart';
import 'package:drever_warr/features/setting/presentation/view/user_information.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';

class VerficationcodeEdetphone extends StatefulWidget {
  final String mobilePhone;
  const VerficationcodeEdetphone({super.key, required this.mobilePhone});

  @override
  State<VerficationcodeEdetphone> createState() =>
      _VerficationcodeEdetphoneState();
}

class _VerficationcodeEdetphoneState extends State<VerficationcodeEdetphone> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateMobileCubit, UpdateMobileState>(
      listener: (context, state) {
        if (state is UpdateMobilePhoneSuccess) {
          FocusScope.of(context).unfocus();
          AppSnackBar.success(context, state.message);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const UserInformation()),
            (route) => false,
          );
        } else if (state is UpdateMobileFailure) {
          AppSnackBar.error(context, state.errMessage);
        }
      },
      builder: (context, state) {
        return OtpVerificationScaffold(
          phone: widget.mobilePhone,
          isLoading: state is UpdateMobileLoading,
          verifyLabelKey: 'verify_button',
          onResend: () {
            context.read<VerificationCubit>().sendVerificationCode(
                  mobilePhone: widget.mobilePhone,
                  typeOfUse: 'change-mobile-phone',
                );
          },
          onVerify: (otp) {
            context
                .read<UpdateMobileCubit>()
                .changeMobilePhone(widget.mobilePhone, otp);
          },
        );
      },
    );
  }
}
