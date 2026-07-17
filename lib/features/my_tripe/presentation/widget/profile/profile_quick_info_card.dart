import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/profile_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileQuickInfoCard extends StatelessWidget {
  const ProfileQuickInfoCard({
    super.key,
    required this.cityName,
    required this.balance,
  });

  final String cityName;
  final num balance;

  String _formatBalance() {
    final value = balance.toDouble();
    final text = value.toStringAsFixed(value % 1 == 0 ? 0 : 2);
    return text.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ProfileUiConstants.cardRadius.r),
        boxShadow: ProfileUiConstants.cardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: _QuickTile(
              icon: Icons.location_city_rounded,
              color: AppColors.main1,
              label: AppTranslations.getText(context, 'governorate'),
              value: cityName.isEmpty ? '—' : cityName,
            ),
          ),
          Container(
            width: 1,
            height: 44.h,
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            color: const Color(0xFFE8ECF1),
          ),
          Expanded(
            child: _QuickTile(
              icon: Icons.account_balance_wallet_rounded,
              color: AppColors.accentOrange,
              label: AppTranslations.getText(context, 'current_balance'),
              value: _formatBalance(),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: color, size: 20.sp),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AuthUiConstants.mutedText,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AuthUiConstants.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
