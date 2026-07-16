import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/models/place_search_result.dart';
import 'package:drever_warr/features/presentation/widgets/location_pick/location_pick_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationPredictionsList extends StatelessWidget {
  const LocationPredictionsList({
    super.key,
    required this.predictions,
    required this.onPredictionTap,
  });

  final List<PlaceSearchResult> predictions;
  final ValueChanged<PlaceSearchResult> onPredictionTap;

  @override
  Widget build(BuildContext context) {
    if (predictions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      constraints: BoxConstraints(maxHeight: 220.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: LocationPickTheme.radius24,
        boxShadow: LocationPickTheme.softShadow,
      ),
      child: ClipRRect(
        borderRadius: LocationPickTheme.radius24,
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 6.h),
          itemCount: predictions.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            color: const Color(0xFFF0F2F6),
            indent: 16.w,
            endIndent: 16.w,
          ),
          itemBuilder: (context, index) {
            final place = predictions[index];
            return InkWell(
              onTap: () => onPredictionTap(place),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: AppColors.main1,
                      size: 20.sp,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            place.shortName,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: LocationPickTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (place.displayName != place.shortName) ...[
                            SizedBox(height: 2.h),
                            Text(
                              place.displayName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: LocationPickTheme.textSecondary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
