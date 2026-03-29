import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/core/constant/app_colors.dart';

class WalletTransactionCard extends StatelessWidget {
  final String date;
  final String amount;
  final bool isCredit; // true للتحويل (بنفسجي)، false للخصم (أحمر)

  const WalletTransactionCard({
    super.key,
    required this.date,
    required this.amount,
    required this.isCredit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        // 1. نجعل الإطار موحد اللون والسماكة ليعمل الـ borderRadius
        border: Border.all(color: AppColors.main1.withOpacity(0.5), width: 1),
        // 2. نستخدم الظل لمحاكاة الخط السفلي السميك (بدون بلر وبإزاحة لأسفل)
        boxShadow: [
          BoxShadow(
            color: AppColors.main1, // نفس لون الخط السفلي الذي تريده
            offset: const Offset(
              0,
              3,
            ), // الإزاحة لأسفل فقط (قيمة الـ 3 هي سماكة الخط)
            blurRadius: 0, // نجعله 0 ليكون الخط حاداً وليس ضبابياً
          ),
          // ظل إضافي جمالي (اختياري)
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 8),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(date, type: AppTextType.bodySmall, color: Colors.black),
          SizedBox(height: 8.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomText(
                " إلى حسابك .",
                type: AppTextType.bodyMedium,
                color: Colors.black,
              ),
              CustomText(
                amount,
                type: AppTextType.bodyMedium,
                color: isCredit ? Colors.purple : Colors.red,
              ),

              CustomText(
                " ل.س ",
                type: AppTextType.bodyMedium,
                color: isCredit ? Colors.purple : Colors.red,
              ),
              CustomText(
                isCredit ? "تم تحويل " : "تم خصم ",
                type: AppTextType.bodyMedium,
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
