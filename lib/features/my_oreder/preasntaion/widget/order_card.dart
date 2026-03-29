import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/my_oreder/preasntaion/view/order_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderCard extends StatelessWidget {
  final OrderButtonStatus buttonStatus;

  const OrderCard({super.key, required this.buttonStatus});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        // 1. تعديل البوردر ليكون أنحف وبنفسجي فاتح جداً (اختياري ليتطابق تماماً)
        border: Border.all(
          color: AppColors.main1.withOpacity(
            0.5,
          ), // جعل الخط أنحف بصرياً عبر الشفافية
          width: 1.5, // تقليل السماكة قليلاً
        ),
        // 2. إضافة الظل الأسود الناعم المتطابق مع الصورة
        boxShadow: [
          BoxShadow(
            // استخدام اللون الأسود مع شفافية منخفضة جداً هو السر
            color: AppColors.main1.withOpacity(0.12),
            // زيادة الـ blur ليكون ناعماً ومنتشراً
            blurRadius: 15,
            // زيادة الـ spread قليلاً ليعطي عمقاً
            spreadRadius: 1,
            // إزاحة الظل للأسفل فقط (كما في الصورة)
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. القسم العلوي (الاسم والمبلغ)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    "الثلاثاء 6 يناير",
                    //  color: Colors.cyan,
                    type: AppTextType.titleSmall,
                  ),
                  SizedBox(height: 5.h),
                  CustomText("10:00 Am", type: AppTextType.titleSmall),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText("عبد الله محمد", type: AppTextType.titleSmall),
                  CustomText("0966621475", type: AppTextType.bodySmall),
                ],
              ),
            ],
          ),

          SizedBox(height: 30.h),

          // 2. قسم المسار والزر (دمج كامل لضبط المستوى)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end, // يبدأ من اليمين
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end, // محاذاة لليسار
                  children: [
                    // إضافة السعر هنا
                    CustomText(
                      "25000 SYP",
                      color: Colors.cyan,
                      type: AppTextType.titleSmall,
                    ),

                    SizedBox(
                      height: 35.h,
                    ), // مسافة ليدفع الزر ليكون بمستوى "الزراعة"

                    _buildActionButton(),
                  ],
                ),
              ),
              // زر القبول في أقصى اليسار
              SizedBox(width: 40.h),
              // نصوص المسار

              // عمود الأيقونات (ColumnSearch)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomText(
                    "مشروع شريح شارع المكاتب",
                    type: AppTextType.bodySmall,
                  ),
                  SizedBox(height: 35.h), // مسافة مطابقة لطول الخط المنقط
                  CustomText("الزراعة", type: AppTextType.bodySmall),
                ],
              ),
              SizedBox(width: 10.w),
              Column(
                children: [
                  Icon(
                    Icons.radio_button_unchecked,
                    color: Colors.grey,
                    size: 18.sp,
                  ),
                  CustomPaint(
                    size: Size(1, 25.h),
                    painter: DashedLinePainter(),
                  ),
                  SvgPicture.asset(
                    IconsAssets.locationsearch,
                    color: AppColors.blue,
                    width: 20.sp,
                  ),
                ],
              ),
              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.end, // محاذاة لليسار
              //     children: [
              //       // إضافة السعر هنا
              //       CustomText(
              //         "25000 SYP",
              //         color: Colors.cyan,
              //         type: AppTextType.titleSmall,
              //       ),

              //       SizedBox(
              //         height: 35.h,
              //       ), // مسافة ليدفع الزر ليكون بمستوى "الزراعة"

              //       _buildActionButton(),
              //     ],
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    bool isAccepted = buttonStatus == OrderButtonStatus.accepted;
    // bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isAccepted ? Colors.white : AppColors.main1,
        border: isAccepted
            ? Border.all(color: AppColors.main1, width: 1.2)
            : null,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        "accept",
        style: GoogleFonts.cairo(fontSize: 14.sp, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 3, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = AppColors.secondary2
      ..strokeWidth = 1;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
