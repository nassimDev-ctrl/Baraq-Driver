import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/customText.dart';
import 'package:drever_warr/features/home/preasntaion/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WaitingReviewScreen extends StatelessWidget {
  const WaitingReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 50.h),
             
            Center(
              child: Image.asset(
                ImageAssets.logo_warr,
                height: 150.h,
                width: 150.w,
              ),
            ),

            const Spacer(),  

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeView()),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 40.h,
                    horizontal: 20.w,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: AppColors.main1,  
                      width: 1.5,
                    ),
                   
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.main1.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomText(
                        "request_sent_waiting",
                        type: AppTextType.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h),
                     
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(flex: 2), 
          ],
        ),
      ),
    );
  }
}
