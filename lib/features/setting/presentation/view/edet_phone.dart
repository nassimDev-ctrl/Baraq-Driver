import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/logging/app_logger.dart';
import 'package:drever_warr/core/utils/validator.dart';
import 'package:drever_warr/core/utils/normalize_number.dart';
import 'package:drever_warr/core/widgets/custom_text_field_all.dart';
import 'package:drever_warr/core/widgets/custom_button.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubit.dart';
import 'package:drever_warr/features/presentation/data/repo/cubit/cubit_verificationRepo/cubite_state.dart';
import 'package:drever_warr/features/presentation/widgets/icon_bak.dart';
import 'package:drever_warr/features/setting/presentation/view/verficationcode_edetphone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EdetPhone extends StatefulWidget {
  const EdetPhone({super.key});

  @override
  State<EdetPhone> createState() => _EdetPhoneState();
}

class _EdetPhoneState extends State<EdetPhone> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary1,
      body: BlocConsumer<VerificationCubit, VerificationState>(
        listener: (context, state) {
          if (state is CreateVerificationCodeSuccess) {
             
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<VerificationCubit>(),
                  child: VerficationcodeEdetphone(
                    mobilePhone: "963${normalizePhone(phoneController.text)}",
                  ),
                ),
              ),
            );
          } else if (state is VerificationFailure) {
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const IconBak(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            ImageAssets.logoWarr,
                            height: 130.h,
                            width: 130.w,
                          ),
                          SizedBox(height: AppSpacing.x45.h),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomText(
                      "edit_mobile_number",
                      type: AppTextType.titleMedium,
                      color: AppColors.secondary2,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomText(
                      "enter_new_mobile_hint",
                      type: AppTextType.titleSmall,
                      color: AppColors.secondary2,
                    ),
                  ),
                  SizedBox(height: AppSpacing.x30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: AppCustomTextField(
                      countryCode: "+963",
                      controller: phoneController,
                      hintText: "",
                      validator: (val) => Validators.isEmptyValue(val, context),
                    ),
                  ),
                  SizedBox(height: 250.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: state is VerificationLoading
                        ? const Center(child: CircularProgressIndicator())
                        : CustomButton(
                            title: "send_verification_code",
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                // 🚀 استدعاء الـ Cubit لإرسال الكود
                                AppLogger.debug("phone phone ${normalizePhone(phoneController.text)}");
                                context
                                    .read<VerificationCubit>()
                                    .sendVerificationCode(
                                      mobilePhone: "963${normalizePhone(phoneController.text) }",
                                      typeOfUse: "change-mobile-phone",
                                    );
                              }
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}