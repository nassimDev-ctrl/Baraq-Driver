import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/widget/wallet/wallet_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.balance,
    this.isLoading = false,
  });

  final num balance;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final currency = AppTranslations.getText(context, 'currency_syp');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(WalletUiConstants.balanceCardRadius.r),
        boxShadow: WalletUiConstants.softShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 72.r,
            height: 72.r,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F7FC),
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.all(10.r),
            child: Image.asset(
              ImageAssets.walletIllustration,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTranslations.getText(context, 'current_balance'),
                  style: TextStyle(
                    color: AuthUiConstants.mutedText,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.h),
                if (isLoading)
                  SizedBox(
                    height: 28.h,
                    width: 28.r,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.main1,
                    ),
                  )
                else
                  Text(
                    '$balance $currency',
                    style: TextStyle(
                      color: AuthUiConstants.textPrimary,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: AppColors.button.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 14.sp,
                        color: AppColors.button,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        AppTranslations.getText(context, 'available_for_withdraw'),
                        style: TextStyle(
                          color: AppColors.button,
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
