import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/profile_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyReviewsWidget extends StatelessWidget {
  const EmptyReviewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: 4.w, bottom: 10.h),
          child: Text(
            AppTranslations.getText(context, 'reviews'),
            style: TextStyle(
              color: AuthUiConstants.mutedText,
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ProfileUiConstants.cardRadius.r),
            boxShadow: ProfileUiConstants.cardShadow,
          ),
          child: Column(
            children: [
              Container(
                width: 68.r,
                height: 68.r,
                decoration: BoxDecoration(
                  color: AppColors.main1.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.reviews_outlined,
                  size: 30.sp,
                  color: AppColors.main1,
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                AppTranslations.getText(context, 'no_reviews'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AuthUiConstants.textPrimary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                AppTranslations.getText(context, 'no_reviews_subtitle'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AuthUiConstants.mutedText,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
