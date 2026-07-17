import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/trips/trips_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyTripsWidget extends StatelessWidget {
  const EmptyTripsWidget({
    super.key,
    required this.onBackHome,
  });

  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 28.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TripsUiConstants.cardRadius.r),
        boxShadow: TripsUiConstants.cardShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            ImageAssets.taxiWebp,
            height: 110.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 16.h),
          Text(
            AppTranslations.getText(context, 'empty_trips_title'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AuthUiConstants.textPrimary,
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            AppTranslations.getText(context, 'empty_trips_subtitle'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AuthUiConstants.mutedText,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              height: 1.4,
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: onBackHome,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.main1,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                AppTranslations.getText(context, 'back_to_home'),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
