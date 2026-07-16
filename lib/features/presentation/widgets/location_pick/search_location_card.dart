import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_theme.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/scale_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchLocationCard extends StatelessWidget {
  const SearchLocationCard({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onSearchTap,
    required this.onUseCurrentLocationTap,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onSearchTap;
  final VoidCallback onUseCurrentLocationTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: LocationPickTheme.radius24,
        boxShadow: LocationPickTheme.cardShadow,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
            child: Row(
              children: [
                Icon(
                  Icons.explore_outlined,
                  color: LocationPickTheme.textPrimary,
                  size: 22.sp,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onChanged: onChanged,
                    onSubmitted: onSubmitted,
                    textInputAction: TextInputAction.search,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: LocationPickTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: AppTranslations.getText(
                        context,
                        'search_address_placeholder',
                      ),
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: LocationPickTheme.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                ScaleTapButton(
                  onTap: onSearchTap,
                  child: Icon(
                    Icons.search_rounded,
                    color: LocationPickTheme.textPrimary,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: const Color(0xFFF0F2F6),
            indent: 16.w,
            endIndent: 16.w,
          ),
          ScaleTapButton(
            onTap: onUseCurrentLocationTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: AppColors.main1,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    AppTranslations.getText(
                      context,
                      'use_my_current_location',
                    ),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: LocationPickTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
