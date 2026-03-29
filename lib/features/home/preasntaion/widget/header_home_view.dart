import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/home/preasntaion/view/menew.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/view/my_profail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HeaderHomeView extends StatefulWidget {
  final VoidCallback onMenuTap;
  const HeaderHomeView({super.key, required this.onMenuTap});

  @override
  State<HeaderHomeView> createState() => _HeaderHomeViewState();
}

class _HeaderHomeViewState extends State<HeaderHomeView> {
  bool _isOnline = true;
  bool soundEnabled = true;
  bool isLangMenuOpen = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 40.h,
        bottom: 20.h,
        // left: 15.w,
        // right: 15.w,
      ),
      decoration: BoxDecoration(
        color: AppColors.main1,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(
        // تجعل العناصر في منتصف العمود تماماً
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: AppSpacing.x25.h),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 20.w),
              GestureDetector(
                onTap: widget.onMenuTap,

                child: SvgPicture.asset(
                  IconsAssets.menu,
                  color: AppColors.secondary1,
                  // width: 25.w,
                ),
              ),
              SizedBox(width: 95.w),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DriverProfail()),
                    );
                  },
                  child: Container(
                    height: 70,
                    //decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: Image.asset(
                      ImageAssets.imageprofail,
                      // height: 70.h,
                      // width: 70.w,
                      //  fit: BoxFit.cover,
                    ),
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

          SizedBox(height: 15.h),

          // النصوص ستكون تحت بعضها وفي المنتصف تماماً بسبب Column
          CustomText(
            "رصيدك الحالي",
            color: Colors.white70,
            type: AppTextType.bodyMedium,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 5.h), // مسافة بسيطة بين النصين

          CustomText(
            "200000 SYP",
            color: Colors.white,
            type: AppTextType.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
