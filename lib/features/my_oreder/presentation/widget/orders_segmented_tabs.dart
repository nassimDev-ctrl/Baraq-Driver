import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/my_oreder/presentation/widget/orders_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersSegmentedTabs extends StatelessWidget {
  const OrdersSegmentedTabs({
    super.key,
    required this.selectedIndex,
    required this.urgentCount,
    required this.scheduledCount,
    required this.onChanged,
  });

  final int selectedIndex;
  final int urgentCount;
  final int scheduledCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(OrdersUiConstants.tabRadius.r),
        boxShadow: OrdersUiConstants.cardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabItem(
              selected: selectedIndex == 0,
              icon: Icons.flash_on_rounded,
              labelKey: 'urgent_orders',
              count: urgentCount,
              onTap: () => onChanged(0),
            ),
          ),
          Expanded(
            child: _TabItem(
              selected: selectedIndex == 1,
              icon: Icons.event_available_rounded,
              labelKey: 'scheduled_orders',
              count: scheduledCount,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.selected,
    required this.icon,
    required this.labelKey,
    required this.count,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String labelKey;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.main1 : AuthUiConstants.mutedText;

    return Material(
      color: selected
          ? AppColors.main1.withValues(alpha: 0.1)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: SizedBox(
          height: 52.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16.sp, color: color),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  AppTranslations.getText(context, labelKey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.main1
                      : const Color(0xFFE8ECF1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: selected ? Colors.white : AuthUiConstants.mutedText,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
