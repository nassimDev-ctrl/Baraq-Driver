import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/data/cubit/model/wallat_model.dart';
import 'package:drever_warr/features/home/presentation/widget/wallet/wallet_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.operation,
    this.animationIndex = 0,
  });

  final WalletOperationModel operation;
  final int animationIndex;

  bool get _isCredit => operation.type == 'charge';

  String _formatDate(String raw) {
    if (raw.isEmpty) return '—';
    final parts = raw.split('T');
    final date = parts.first;
    final time = parts.length > 1 ? parts[1].split('.').first : '';
    if (time.isEmpty) return date;
    final hhmm = time.length >= 5 ? time.substring(0, 5) : time;
    return '$date  ·  $hhmm';
  }

  @override
  Widget build(BuildContext context) {
    final currency = AppTranslations.getText(context, 'currency_syp');
    final accent = _isCredit ? AppColors.button : AppColors.accentOrange;
    final titleKey = _isCredit ? 'transaction_sent' : 'transaction_deducted';
    final sign = _isCredit ? '+' : '-';

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 280 + (animationIndex * 40).clamp(0, 240)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 12),
            child: child,
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(WalletUiConstants.transactionCardRadius.r),
          boxShadow: WalletUiConstants.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                _isCredit ? Icons.south_west_rounded : Icons.north_east_rounded,
                color: accent,
                size: 22.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTranslations.getText(context, titleKey).trim(),
                    style: TextStyle(
                      color: AuthUiConstants.textPrimary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _formatDate(operation.date),
                    style: TextStyle(
                      color: AuthUiConstants.mutedText,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: AppColors.button.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      AppTranslations.getText(context, 'completed'),
                      style: TextStyle(
                        color: AppColors.button,
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              '$sign${operation.amount} $currency',
              style: TextStyle(
                color: accent,
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
