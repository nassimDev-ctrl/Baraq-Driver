import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/api_constants.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/profile_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.imagePath,
    required this.fullName,
    required this.phone,
    required this.rating,
    required this.reviewsCount,
    required this.isOnline,
  });

  final String? imagePath;
  final String fullName;
  final String phone;
  final num rating;
  final int reviewsCount;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = ApiConstants.resolveMediaUrl(imagePath);
    final name = fullName.trim().isEmpty ? '—' : fullName.trim();
    final avatarRadius = ProfileUiConstants.avatarSize.r;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: avatarRadius / 2),
          padding: EdgeInsets.fromLTRB(
            18.w,
            (avatarRadius / 2) + 14.h,
            18.w,
            18.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ProfileUiConstants.cardRadius.r),
            boxShadow: ProfileUiConstants.softShadow,
          ),
          child: Column(
            children: [
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AuthUiConstants.textPrimary,
                  fontSize: 21.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 10.h),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _Pill(
                    background: isOnline
                        ? AppColors.button.withValues(alpha: 0.12)
                        : const Color(0xFFF3F4F6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: isOnline
                                ? AppColors.button
                                : const Color(0xFF9CA3AF),
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          AppTranslations.getText(
                            context,
                            isOnline ? 'driver_online' : 'driver_offline',
                          ),
                          style: TextStyle(
                            color: isOnline
                                ? AppColors.button
                                : AuthUiConstants.mutedText,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _Pill(
                    background: const Color(0xFFFFF7E6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 15.sp,
                          color: const Color(0xFFF59E0B),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                            color: AuthUiConstants.textPrimary,
                            fontSize: 12.5.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '($reviewsCount)',
                          style: TextStyle(
                            color: AuthUiConstants.mutedText,
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F8FC),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.phone_rounded,
                      size: 16.sp,
                      color: AppColors.main1,
                    ),
                    SizedBox(width: 8.w),
                    Flexible(
                      child: Text(
                        phone,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AuthUiConstants.textPrimary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: avatarRadius,
                height: avatarRadius,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.14),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: resolvedUrl != null
                      ? Image.network(
                          resolvedUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            ImageAssets.imageprofail,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          ImageAssets.imageprofail,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                right: 4.w,
                bottom: 6.h,
                child: Container(
                  width: 18.r,
                  height: 18.r,
                  decoration: BoxDecoration(
                    color: isOnline
                        ? AppColors.button
                        : const Color(0xFF9CA3AF),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.background, required this.child});

  final Color background;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: child,
    );
  }
}
