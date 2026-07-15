import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/features/home/presentation/view/home_view.dart';
import 'package:drever_warr/features/presentation/view/waiting_review_screen.dart';
import 'package:drever_warr/features/presentation/view/location_drever.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/cash/preferences_service.dart';
 

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }


  Future<void> _checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    await CacheManager.reload();

    final token = await CacheManager.getData(CacheManager.tokenKey);
    final status = await CacheManager.getData(CacheManager.statusKey);

    if (!mounted) return;

    final hasToken = token != null && token.trim().isNotEmpty;
    if (!hasToken) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AddLocation()),
      );
      return;
    }

    final normalizedStatus = status?.trim().toLowerCase();
    if (normalizedStatus == 'waiting' || normalizedStatus == 'rejected') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WaitingReviewScreen()),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
           
            const Spacer(),

            
            Image.asset(
              ImageAssets.logoWarr,
              width: 250.w,
              height: 250.h,
              fit: BoxFit.contain,
            ),

           
            const Spacer(),

           
            Padding(
              padding: EdgeInsets.only(
                bottom: 50.h,
              ),  
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
