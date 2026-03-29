import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/transleat/app_translat.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/home/preasntaion/widget/WalletTransactionCard.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // زر الرجوع
            IconBak(),
            SizedBox(height: 25.h),
            // الرصيد الحالي
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppTranslations.getText(context, "wallet_record"),
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue,
                    ),
                  ),
                  // CustomText(
                  //   "رصيدك الحالي",
                  //   type: AppTextType.titleLarge,
                  //   color: AppColors.blue,
                  // ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppTranslations.getText(context, "200000 SYP"),
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.main1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    AppTranslations.getText(context, "current_balance"),
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            // قائمة العمليات
            Expanded(
              child: ListView(
                children: const [
                  WalletTransactionCard(
                    date: "10/5/2025",
                    amount: "500000",
                    isCredit: true,
                  ),
                  WalletTransactionCard(
                    date: "12/5/2025",
                    amount: "10000",
                    isCredit: false,
                  ),
                  WalletTransactionCard(
                    date: "20/5/2025",
                    amount: "400000",
                    isCredit: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
