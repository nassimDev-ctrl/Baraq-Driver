 
import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/view/my_profail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HeaderHomeView extends StatefulWidget {
  final VoidCallback onMenuTap;
  final String? imagePath;  
final num driverBalance;
  const HeaderHomeView({
    super.key, 
    required this.driverBalance,
    required this.onMenuTap, 
    this.imagePath,  
  });

  @override
  State<HeaderHomeView> createState() => _HeaderHomeViewState();
}

class _HeaderHomeViewState extends State<HeaderHomeView> {
  bool soundEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 40.h,
        bottom: 20.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.main1,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: AppSpacing.x25.h),
          Row(
            children: [
              SizedBox(width: 20.w),
              // زر القائمة (Menu)
              GestureDetector(
                onTap: widget.onMenuTap,
                child: SvgPicture.asset(
                  IconsAssets.menu,
                  color: AppColors.secondary1,
                ),
              ),
              
              const Spacer(),  

               
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DriverProfail()),
                  );
                },
                child: _profileAvatar(widget.imagePath),
              ),

              const Spacer(),

             
              GestureDetector(
                onTap: () {
                  setState(() {
                    soundEnabled = !soundEnabled;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 50.w,
                  height: 26.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: soundEnabled
                        ? const Color(0xFF1595C7)
                        : Colors.grey.shade400,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment: soundEnabled
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      width: 20.w,
                      height: 20.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20.w),
            ],
          ),

          SizedBox(height: 15.h),

          CustomText(
            "current_balance",
            color: Colors.white70,
            type: AppTextType.bodyMedium,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 5.h),

        CustomText(
            "${widget.driverBalance} SYP", // عرض الرصيد هنا
            color: Colors.white,
            type: AppTextType.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  
  Widget _profileAvatar(String? imagePath) {
    const String baseUrl = 'https://api.taxiwaar.com/';

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),  
      ),
      child: CircleAvatar(
        radius: 35.r,
        backgroundColor: Colors.grey[200],
        child: ClipOval(
          child: (imagePath != null && imagePath.isNotEmpty)
              ? Image.network(
                  imagePath.startsWith('http') ? imagePath : "$baseUrl$imagePath",
                  width: 70.r,
                  height: 70.r,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset(ImageAssets.imageprofail, fit: BoxFit.cover),
                )
              : Image.asset(ImageAssets.imageprofail, fit: BoxFit.cover),
        ),
      ),
    );
  }
}