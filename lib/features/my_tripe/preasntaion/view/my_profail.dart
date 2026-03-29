import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/ColumnImageNamePhoneProfaildriver.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/ColumnNumberOfTripsRatingDistancesDriveprofail.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/ColumnTypecarePhondrive.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/OpinionsAboutDrive.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriverProfail extends StatefulWidget {
  const DriverProfail({super.key});

  @override
  State<DriverProfail> createState() => _DriverProfailState();
}

class _DriverProfailState extends State<DriverProfail> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Column(
          children: [
            IconBak(),
            SizedBox(height: AppSpacing.lg.h),
            ColumnImageNamePhoneProfaildriver(),
            SizedBox(height: AppSpacing.xlg.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ColumnNumberOfTripsRatingDistancesDriveprofail(
                  image: IconsAssets.distances,
                  title1: "30 k.m",
                  title2: "distances",
                  col: AppColors.secondary2,
                ),
                ColumnNumberOfTripsRatingDistancesDriveprofail(
                  image: IconsAssets.stare,
                  title1: "4.5",
                  title2: "rating",
                  col: Colors.yellow,
                ),
                ColumnNumberOfTripsRatingDistancesDriveprofail(
                  col: AppColors.secondary2,
                  image: IconsAssets.Numberoftrips,
                  title1: "20",
                  title2: "trips_count",
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
              child: ColumnTypecarePhondrive(
                carNumber: "100",
                carType: "xxxxxx",
                driverPhone: "0996688957",
                colors: AppColors.secondary2,
                diplay: false,
                tybe: AppTextType.bodyLarge,
              ),
            ),
            SizedBox(height: AppSpacing.xs.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => MyTripes()),
                      // );
                    },
                    child: CustomText(
                      "reviews",
                      type: AppTextType.titleMedium,
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: OpinionsAboutDrive(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
