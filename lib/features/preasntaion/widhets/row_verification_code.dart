import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:flutter/material.dart';
  
 
// class RowVerificationCode extends StatelessWidget {
//   const RowVerificationCode({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         CustomText(
//           "إعادة إرسال رمز التحقق",
//           type: AppTextType.titleSmall,
//           color: AppColors.button,
//         ),
//         CustomText(
//           "لم يتم إرسال الرمز ؟",
//           type: AppTextType.titleSmall,
//           color: AppColors.secondary1,
//         ),
//       ],
//     );
//   }
// }
class RowVerificationCode extends StatelessWidget {
  final VoidCallback onResend; // أضفنا هذا السطر

  const RowVerificationCode({
    super.key,
    required this.onResend,
  }); // أضفناه هنا أيضاً

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          // أضفنا حساس للضغط
          onTap: onResend,
          child: CustomText(
            "resend_verification_code",
            type: AppTextType.titleSmall,
            color: AppColors.button,
          ),
        ),
        CustomText(
          "code_not_sent_question", // أضف مسافات بسيطة للتنسيق
          type: AppTextType.titleSmall,
          color: AppColors.secondary2,
        ),
      ],
    );
  }
}
