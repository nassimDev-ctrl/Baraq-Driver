import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/features/preasntaion/widhets/regster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    // الانتقال التلقائي بعد 3 ثوانٍ
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Regsterview()),
        );
      }
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            // مساحة مرنة علوية لدفع الشعار للمنتصف
            const Spacer(),

            // الشعار في المنتصف
            Image.asset(
              ImageAssets.logo_warr,
              width: 250.w,
              height: 250.h,
              fit: BoxFit.contain,
            ),

            // مساحة مرنة تدفع الـ Row للأسفل
            const Spacer(),

            // مؤشر التقدم السفلي
            Padding(
              padding: EdgeInsets.only(
                bottom: 50.h,
              ), // مسافة عن حافة الشاشة السفلية
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProgressStep(isActive: true),
                  SizedBox(width: 8.w),
                  _buildProgressStep(isActive: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ويدجت مخصص لرسم الخطوط البنفسجية في الأسفل
  Widget _buildProgressStep({required bool isActive}) {
    return Container(
      width: 60.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF9C46D1) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}
