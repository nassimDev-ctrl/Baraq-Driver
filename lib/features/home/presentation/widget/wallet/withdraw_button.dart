import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';
import 'package:drever_warr/features/home/presentation/widget/wallet/wallet_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WithdrawButton extends StatelessWidget {
  const WithdrawButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          WalletUiConstants.horizontalPadding.w,
          8.h,
          WalletUiConstants.horizontalPadding.w,
          12.h,
        ),
        child: SizedBox(
          width: double.infinity,
          height: WalletUiConstants.withdrawButtonHeight.h,
          child: ElevatedButton(
            onPressed: () {
              AppSnackBar.info(
                context,
                AppTranslations.getText(context, 'coming_soon'),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentOrange,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  WalletUiConstants.withdrawButtonRadius.r,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payments_outlined, size: 22.sp),
                SizedBox(width: 8.w),
                Text(
                  AppTranslations.getText(context, 'request_profit_withdrawal'),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
