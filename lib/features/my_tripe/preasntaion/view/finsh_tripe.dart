import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/view/details_trip.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/CountainerJournyOngoing.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// استيراد الكلاس الذي صممناه في الخطوة السابقة
// import 'package:your_project/widgets/countainer_journy_ongoing.dart';

class FinishedTripsScreen extends StatelessWidget {
  const FinishedTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          IconBak(),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText(
                  "finished_trips",
                  color: Colors.blue.shade400, // اللون السماوي في الصورة
                  type: AppTextType
                      .titleMedium, // تأكدي من وجود هذا النوع في CustomText
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              itemCount: 5, // عدد افتراضي للرحلات
              itemBuilder: (context, index) {
                // استخدام الكلاس الخاص بكِ هنا
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsOfTheCompletedTrip(),
                        ),
                      );
                    },
                    child: const CountainerJournyOngoing(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
