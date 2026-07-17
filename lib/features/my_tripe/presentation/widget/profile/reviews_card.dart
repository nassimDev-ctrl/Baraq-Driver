import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/profile_review_tile.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/profile/profile_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingDistribution extends StatelessWidget {
  const RatingDistribution({
    super.key,
    required this.counts,
  });

  /// Index 0 = 1 star … index 4 = 5 stars.
  final List<int> counts;

  @override
  Widget build(BuildContext context) {
    final maxCount = counts.fold<int>(0, (m, c) => c > m ? c : m);

    return Column(
      children: [
        for (var star = 5; star >= 1; star--) ...[
          if (star < 5) SizedBox(height: 7.h),
          _BarRow(
            star: star,
            count: counts[star - 1],
            maxCount: maxCount == 0 ? 1 : maxCount,
          ),
        ],
      ],
    );
  }
}

class _BarRow extends StatelessWidget {
  const _BarRow({
    required this.star,
    required this.count,
    required this.maxCount,
  });

  final int star;
  final int count;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    final ratio = (count / maxCount).clamp(0.0, 1.0);

    return Row(
      children: [
        SizedBox(
          width: 12.w,
          child: Text(
            '$star',
            style: TextStyle(
              color: AuthUiConstants.mutedText,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Icon(Icons.star_rounded, size: 12.sp, color: const Color(0xFFF59E0B)),
        SizedBox(width: 6.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: SizedBox(
              height: 7.h,
              child: Stack(
                children: [
                  Container(color: const Color(0xFFE8EDF4)),
                  FractionallySizedBox(
                    widthFactor: ratio,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.main1.withValues(alpha: 0.75),
                            AppColors.main1,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 28.w,
          child: Text(
            '$count',
            textAlign: TextAlign.end,
            style: TextStyle(
              color: AuthUiConstants.mutedText,
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class ReviewsCard extends StatelessWidget {
  const ReviewsCard({
    super.key,
    required this.averageRating,
    required this.reviewsCount,
    required this.distribution,
    required this.previewNotes,
    required this.previewRatings,
    required this.onViewAll,
  });

  final num averageRating;
  final int reviewsCount;
  final List<int> distribution;
  final List<String> previewNotes;
  final List<double> previewRatings;
  final VoidCallback onViewAll;

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
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ProfileUiConstants.cardRadius.r),
            boxShadow: ProfileUiConstants.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9FC),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Text(
                            averageRating.toStringAsFixed(1),
                            style: TextStyle(
                              color: AuthUiConstants.textPrimary,
                              fontSize: 34.sp,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              final filled = index < averageRating.round();
                              return Icon(
                                filled
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 16.sp,
                                color: filled
                                    ? const Color(0xFFF59E0B)
                                    : const Color(0xFFD1D5DB),
                              );
                            }),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            AppTranslations.getText(context, 'ratings_count')
                                .replaceAll('{n}', '$reviewsCount'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AuthUiConstants.mutedText,
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      flex: 6,
                      child: RatingDistribution(counts: distribution),
                    ),
                  ],
                ),
              ),
              if (previewNotes.isNotEmpty) ...[
                SizedBox(height: 14.h),
                for (var i = 0; i < previewNotes.length; i++)
                  ProfileReviewTile(
                    note: previewNotes[i],
                    rating: previewRatings[i],
                  ),
              ],
              SizedBox(height: 4.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: onViewAll,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.main1.withValues(alpha: 0.1),
                    foregroundColor: AppColors.main1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text(
                        AppTranslations.getText(context, 'view_all_reviews'),
                        style: TextStyle(
                          fontSize: 13.5.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
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
