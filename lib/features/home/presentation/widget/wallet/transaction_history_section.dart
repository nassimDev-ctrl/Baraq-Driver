import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/model/wallat_model.dart';
import 'package:drever_warr/features/home/presentation/widget/wallet/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionHistorySection extends StatelessWidget {
  const TransactionHistorySection({
    super.key,
    required this.operations,
  });

  final List<WalletOperationModel> operations;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                AppTranslations.getText(context, 'wallet_operations_history'),
                style: TextStyle(
                  color: AuthUiConstants.textPrimary,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: AppColors.main1,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                AppTranslations.getText(context, 'view_all'),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        if (operations.isEmpty)
          _EmptyOperations()
        else
          ...List.generate(
            operations.length,
            (index) => TransactionCard(
              operation: operations[index],
              animationIndex: index,
            ),
          ),
      ],
    );
  }
}

class _EmptyOperations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            size: 42.sp,
            color: AuthUiConstants.iconMuted,
          ),
          SizedBox(height: 12.h),
          Text(
            AppTranslations.getText(context, 'no_wallet_operations'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AuthUiConstants.mutedText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
