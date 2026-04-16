import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:flutter/material.dart';

class TextVerificationCode extends StatelessWidget {
  const TextVerificationCode({super.key, required this.phone});
  final String phone;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          "verification_code_sent",
          type: AppTextType.titleSmall,
          color: AppColors.secondary2,
        ),
        SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              phone,

              type: AppTextType.titleSmall,
              color: AppColors.error,
            ),
            CustomText(
              "verification_code_sent",
              type: AppTextType.titleSmall,
              color: AppColors.secondary2,
            ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        CustomText(
          "enter_code_instruction",
          type: AppTextType.titleSmall,
          color: AppColors.secondary2,
        ),
        SizedBox(height: AppSpacing.sm),
        CustomText(
          "verify_identity",
          type: AppTextType.titleSmall,
          color: AppColors.secondary2,
        ),
      ],
    );
  }
}
