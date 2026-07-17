import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/profile_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileReviewTile extends StatelessWidget {
  const ProfileReviewTile({
    super.key,
    required this.note,
    required this.rating,
  });

  final String note;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: ProfileUiConstants.cardShadow,
        border: Border.all(color: const Color(0xFFF0F3F7)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: AppColors.main1.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.person_rounded,
              color: AppColors.main1,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(5, (index) {
                    final filled = index < rating.round();
                    return Icon(
                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 15.sp,
                      color: filled
                          ? const Color(0xFFF59E0B)
                          : const Color(0xFFD1D5DB),
                    );
                  }),
                ),
                SizedBox(height: 8.h),
                Text(
                  note.isEmpty ? '—' : note,
                  style: TextStyle(
                    color: AuthUiConstants.textPrimary,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
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
