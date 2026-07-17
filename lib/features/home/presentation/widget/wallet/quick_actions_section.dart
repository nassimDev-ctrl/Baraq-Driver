import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/app_snack_bar.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/widget/wallet/scale_tap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  void _comingSoon(BuildContext context) {
    AppSnackBar.info(
      context,
      AppTranslations.getText(context, 'coming_soon'),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Visual order matches the design: left → right
    final actions = [
      _ActionItem(
        labelKey: 'withdraw_request',
        icon: Icons.file_download_outlined,
        color: AppColors.accentOrange,
      ),
      _ActionItem(
        labelKey: 'transfer',
        icon: Icons.file_upload_outlined,
        color: const Color(0xFF8B5CF6),
      ),
      _ActionItem(
        labelKey: 'statistics',
        icon: Icons.bar_chart_rounded,
        color: AppColors.button,
      ),
      _ActionItem(
        labelKey: 'account_statement',
        icon: Icons.description_outlined,
        color: const Color(0xFF3B82F6),
      ),
    ];

    return Directionality(
      textDirection: TextDirection.ltr,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < actions.length; i++) ...[
              if (i > 0) SizedBox(width: 10.w),
              Expanded(
                child: _QuickActionCard(
                  item: actions[i],
                  onTap: () => _comingSoon(context),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.item,
    required this.onTap,
  });

  final _ActionItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16.r);

    return ScaleTap(
      onTap: onTap,
      borderRadius: radius,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: radius,
          border: Border.all(color: const Color(0xFFE8ECF1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: item.color,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(item.icon, color: Colors.white, size: 24.sp),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 32.h,
              child: Center(
                child: Text(
                  AppTranslations.getText(context, item.labelKey),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AuthUiConstants.textPrimary,
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItem {
  const _ActionItem({
    required this.labelKey,
    required this.icon,
    required this.color,
  });

  final String labelKey;
  final IconData icon;
  final Color color;
}
