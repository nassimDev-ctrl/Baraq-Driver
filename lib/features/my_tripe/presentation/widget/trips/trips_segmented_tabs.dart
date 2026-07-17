import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/trips/trips_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsSegmentedTabs extends StatelessWidget {
  const TripsSegmentedTabs({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TripsUiConstants.tabRadius.r),
        boxShadow: TripsUiConstants.cardShadow,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = (constraints.maxWidth - 0) / 2;
          return Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeOutCubic,
                alignment: selectedIndex == 0
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: tabWidth,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: AppColors.main1.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _TabItem(
                      selected: selectedIndex == 0,
                      icon: Icons.speed_rounded,
                      labelKey: 'current_trip',
                      onTap: () => onChanged(0),
                    ),
                  ),
                  Expanded(
                    child: _TabItem(
                      selected: selectedIndex == 1,
                      icon: Icons.history_rounded,
                      labelKey: 'finished_trips',
                      onTap: () => onChanged(1),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.selected,
    required this.icon,
    required this.labelKey,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String labelKey;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.main1 : AuthUiConstants.mutedText;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: SizedBox(
        height: 48.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
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
              ],
            ),
            SizedBox(height: 6.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              height: 3.h,
              width: selected ? 42.w : 0,
              decoration: BoxDecoration(
                color: selected ? AppColors.main1 : Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
