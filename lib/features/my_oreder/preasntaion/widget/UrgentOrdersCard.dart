import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/view/order_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
// تأكد من مسارات الملفات لديك
// import 'package:drever_warr/core/asset/icon_asset.dart';
// import 'package:drever_warr/core/constant/app_colors.dart';
// import 'package:drever_warr/core/widgets/customText.dart';

class UrgentOrdersCard extends StatelessWidget {
  final OrderButtonStatus buttonStatus;

  const UrgentOrdersCard({super.key, required this.buttonStatus});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // لضمان الترتيب من اليمين لليسار
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),

          // الحدود البنفسجية الخفيفة
          border: Border.all(
            color: const Color(0xFF9C4DB9).withOpacity(0.5),
            width: 1,
          ),

          // الشادو البنفسجي الناعم
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9C4DB9).withOpacity(0.2),
              blurRadius: 16, // نعومة الشادو
              spreadRadius: 0, // بدون انتشار زائد
              offset: const Offset(0, 6), // نزول لتحت مثل الصورة
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- القسم الأيمن: النصوص والمسار ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText("عبد الله محمد", type: AppTextType.bodySmall),
                  CustomText("0966621475", type: AppTextType.bodySmall),
                  SizedBox(height: 20.h),

                  // قسم تتبع المسار (النقطة، الخط، الموقع)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.radio_button_unchecked,
                            color: Colors.grey,
                            size: 16.sp,
                          ),
                          CustomPaint(
                            size: Size(1, 30.h),
                            painter: DashedLinePainter(),
                          ),
                          Icon(
                            Icons.location_on,
                            color: AppColors.blue,
                            size: 20.sp,
                          ),
                        ],
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              "مشروع شريح شارع المكاتب",
                              type: AppTextType.bodySmall,
                            ),
                            SizedBox(height: 25.h),
                            CustomText("الزراعة", type: AppTextType.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- القسم الأيسر: السعر، المسافة، والزر ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      "25000 SYP",
                      color: Colors.cyan,
                      type: AppTextType.titleSmall,
                    ),
                    CustomText(
                      "4 K.m",
                      type: AppTextType.bodySmall,
                      color: TextColors.textDisabled,
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.h,
                ), // مسافة لدفع الزر للأسفل محاذاة لـ "الزراعة"
                _buildActionButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    bool isAccepted = buttonStatus == OrderButtonStatus.accepted;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isAccepted ? Colors.white : const Color(0xFF9C4DB9),
        border: Border.all(color: const Color(0xFF9C4DB9), width: 1.2),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: CustomText(
        isAccepted ? "accept" : "accept",
        color: isAccepted ? AppColors.secondary2 : AppColors.secondary1,
        type: AppTextType.titleSmall,
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 3, dashSpace = 2, startY = 0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
