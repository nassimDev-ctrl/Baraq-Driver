import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HeaderOrder extends StatefulWidget {
  final VoidCallback onMenuTap;
  final bool con;
  const HeaderOrder({super.key, required this.onMenuTap, required this.con});

  @override
  State<HeaderOrder> createState() => _HeaderOrderState();
}

class _HeaderOrderState extends State<HeaderOrder> {
  bool _isOnline = true;
  bool soundEnabled = true;
  bool isLangMenuOpen = false;
  bool cont = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // ليأخذ العمود أصغر مساحة ممكنة
      children: [
        SizedBox(height: 40.h),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 20.w),
            GestureDetector(
              onTap: widget.onMenuTap,

              child: SvgPicture.asset(
                IconsAssets.menu,
                color: AppColors.secondary2,
                // width: 25.w,
              ),
            ),
            SizedBox(width: 95.w),
            Center(
              child: Container(
                height: 70,
                //decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Image.asset(
                  ImageAssets.imageprofail,
                  height: 65.h,
                  width: 65.w,
                  //  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 80.w),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50.w, // عرض الزر
              height: 26.h, // ارتفاع الزر
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                // تغيير اللون بناءً على الحالة (أزرق في التفعيل، رمادي في الإيقاف)
                color: soundEnabled
                    ? const Color(0xFF1595C7)
                    : Colors.grey.shade400,
              ),
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                // تحريك الدائرة يمين أو يسار حسب الحالة
                alignment: soundEnabled
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // الدائرة البيضاء
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        if (widget.con)
          Container(
            width: double.infinity,
            //margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
            decoration: BoxDecoration(
              color: AppColors.main1,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
            child: CustomText(
              "هناك 5 طلبات فورية و 6 طلبات مجدولة",
              color: Colors.white,
              textAlign: TextAlign.right, // محاذاة لليمين
              type: AppTextType.bodyMedium,
            ),
          ),
        // النصوص في المنتصف تماماً
      ],
    );
  }
}
