import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColumnTypecarePhondrive extends StatelessWidget {
  const ColumnTypecarePhondrive({
    super.key,
    required this.diplay,
    required this.tybe,
    required this.colors,
    required this.carType, 
    required this.carNumber, 
    required this.driverPhone,  
  });

  final bool diplay;
  final AppTextType tybe;
  final Color colors;
  final String carType;
  final String carNumber;
  final String driverPhone;

  @override
  Widget build(BuildContext context) {
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Column(
      children: [
        isArabic
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(carType, type: tybe, color: colors),
                  CustomText("car_type", type: tybe, color: colors),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText("car_type", type: tybe, color: colors),
                  CustomText(carType, type: tybe, color: colors),
                ],
              ),
        SizedBox(height: AppSpacing.xs.h),
        isArabic
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(carNumber, type: tybe, color: colors),
                  CustomText("car_number", type: tybe, color: colors),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText("car_number", type: tybe, color: colors),
                  CustomText(carNumber, type: tybe, color: colors),
                ],
              ),
        if (diplay) ...[
          SizedBox(height: AppSpacing.xs.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(driverPhone, type: AppTextType.bodyMedium),
              CustomText("رقم السائق", type: AppTextType.bodyMedium),
            ],
          ),
        ],
      ],
    );
  }
}

 