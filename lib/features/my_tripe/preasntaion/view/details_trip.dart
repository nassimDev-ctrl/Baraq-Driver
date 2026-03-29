// import 'package:drever_warr/core/asset/icon_asset.dart';
// import 'package:drever_warr/core/asset/image_asset.dart';
// import 'package:drever_warr/core/constant/app_colors.dart';
// import 'package:drever_warr/core/constant/app_spacing.dart';
// import 'package:drever_warr/core/widgets/customText.dart';
// import 'package:drever_warr/core/widgets/customTextFieldsearch.dart';
// import 'package:drever_warr/features/my_tripe/preasntaion/widget/TopColoumnDetailsTripEnd.dart';
// import 'package:drever_warr/features/my_tripe/preasntaion/widget/detals_row.dart';
// import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';

// class DetailsOfTheCompletedTrip extends StatefulWidget {
//   const DetailsOfTheCompletedTrip({super.key});

//   @override
//   State<DetailsOfTheCompletedTrip> createState() =>
//       _DetailsOfTheCompletedTripState();
// }

// class _DetailsOfTheCompletedTripState extends State<DetailsOfTheCompletedTrip> {
//   final TextEditingController option = TextEditingController();
//   double userRating = 4.0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start, // محاذاة العناصر لليمين
//           children: [
//             SizedBox(height: 40.h),
//             const IconBak(), // زر الرجوع
//             // 1. عنوان "تفاصيل الرحلة"
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
//               child: CustomText(
//                 "تفاصيل الرحلة",
//                 type: AppTextType.titleMedium,
//                 color: AppColors.blue,
//               ),
//             ),

//             // 2. كرت المسار (السيارة والموقع)
//             TopColoumnDetailsTripEnd(),
//             SizedBox(height: AppSpacing.lg.h),

//             // 3. قسم بيانات المسافة والوقت
//             _buildInfoRow("6.25 m", "المسافة :"),
//             _buildInfoRow("10 min", "وقت داخل السيارة :"),
//             _buildInfoRow("1 min", "وقت الانتظار :"),

//             SizedBox(height: AppSpacing.xxxxlg.h),

//             // 4. قسم اسم العميل (أو السفير)
//             _buildSectionTitle("اسم العميل :"),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomText(
//                     "عبدالله محمد محمد",
//                     color: Colors.black,
//                     type: AppTextType.titlelarge,
//                   ),
//                   CustomText(
//                     "0966655444",
//                     color: Colors.black,
//                     type: AppTextType.titlelarge,
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(height: AppSpacing.xxxxlg.h),

//             // 5. قسم تفاصيل الفاتورة
//             _buildSectionTitle("تفاصيل الفاتورة :"),
//             _buildInfoRow("15000 SYP", "سعر الرحلة :"),
//             _buildInfoRow("0 SYP", "الخصم :"),
//             _buildInfoRow("15000 SYP", "المجموع :"),
//             _buildInfoRow("1200 SYP", "عمولة الإدارة:"),
//             _buildInfoRow("نقداً", "طريقة الدفع :"),

//             SizedBox(height: AppSpacing.xxxxlg.h),

//             // 6. قسم التقييم
//             _buildSectionTitle("تقييمك :"),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24.w),
//               child: Row(
//                 mainAxisAlignment:
//                     MainAxisAlignment.end, // النجوم تبدأ من اليمين
//                 children: List.generate(5, (index) {
//                   return Icon(
//                     index < 4 ? Icons.star : Icons.star_border,
//                     color: Colors.amber,
//                     size: 30.sp,
//                   );
//                 }),
//               ),
//             ),

//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
//               child: CustomText(
//                 ". الرحلة ممتازة",
//                 type: AppTextType.bodyMedium,
//               ),
//             ),

//             SizedBox(height: 50.h),
//           ],
//         ),
//       ),
//     );
//   }

//   // ودجت مساعد لرسم العناوين الزرقاء
//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           CustomText(title, type: AppTextType.bodyLarge, color: AppColors.blue),
//         ],
//       ),
//     );
//   }

//   // ودجت مساعد لرسم صفوف البيانات (نص يمين ونص يسار)
//   Widget _buildInfoRow(String value, String label) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           CustomText(label, type: AppTextType.titleSmall, color: Colors.black),
//           CustomText(value, type: AppTextType.titleSmall, color: Colors.black),
//         ],
//       ),
//     );
//   }
// }
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/TopColoumnDetailsTripEnd.dart';
import 'package:drever_warr/features/preasntaion/widhets/icon_bak.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsOfTheCompletedTrip extends StatefulWidget {
  const DetailsOfTheCompletedTrip({super.key});

  @override
  State<DetailsOfTheCompletedTrip> createState() =>
      _DetailsOfTheCompletedTripState();
}

class _DetailsOfTheCompletedTripState extends State<DetailsOfTheCompletedTrip> {
  final TextEditingController option = TextEditingController();
  double userRating = 4.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(height: 40.h),
            const IconBak(),

            // 1. عنوان "تفاصيل الرحلة"
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              child: CustomText(
                "trip_details",
                type: AppTextType.titleMedium,
                color: AppColors.blue,
              ),
            ),

            // 2. كرت المسار
            TopColoumnDetailsTripEnd(),
            SizedBox(height: AppSpacing.lg.h),

            // 3. قسم بيانات المسافة والوقت
            _buildInfoRow("6.25 m", "distance"),
            _buildInfoRow("10 min", "in_car_time"),
            _buildInfoRow("1 min", "waiting_time"),

            SizedBox(height: AppSpacing.xxxxlg.h),

            // 4. قسم اسم العميل
            _buildSectionTitle("client_name"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    "عبدالله محمد محمد", // عادة تأتي من API فلا تترجم
                    color: Colors.black,
                    type: AppTextType.titlelarge,
                  ),
                  CustomText(
                    "0966655444",
                    color: Colors.black,
                    type: AppTextType.titlelarge,
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xxxxlg.h),

            // 5. قسم تفاصيل الفاتورة
            _buildSectionTitle("invoice_details"),
            _buildInfoRow("15000", "trip_price"),
            _buildInfoRow("0", "discount"),
            _buildInfoRow("15000", "total"),
            _buildInfoRow("1200 ", "admin_commission"),
            _buildInfoRow("cash", "payment_method"),

            SizedBox(height: AppSpacing.xxxxlg.h),

            // 6. قسم التقييم
            _buildSectionTitle("your_rating"),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(5, (index) {
                  return Icon(
                    index < 4 ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 30.sp,
                  );
                }),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
              child: CustomText("excellent_trip", type: AppTextType.bodyMedium),
            ),

            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomText(title, type: AppTextType.bodyLarge, color: AppColors.blue),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String value, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(value, type: AppTextType.titleSmall, color: Colors.black),
          CustomText(label, type: AppTextType.titleSmall, color: Colors.black),
        ],
      ),
    );
  }
}
