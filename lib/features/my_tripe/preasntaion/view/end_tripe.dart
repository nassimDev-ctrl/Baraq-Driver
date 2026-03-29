import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/features/my_tripe/preasntaion/widget/TripLocationPath.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EndTripe extends StatefulWidget {
  @override
  _EndTripeState createState() => _EndTripeState();
}

class _EndTripeState extends State<EndTripe> {
  // إحداثيات افتراضية لمدينة اللاذقية
  // static const LatLng _startPoint = LatLng(35.5247, 35.7767);
  // static const LatLng _endPoint = LatLng(35.5111, 35.7922);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. الخارطة في الخلفية
          // GoogleMap(
          //   initialCameraPosition: CameraPosition(
          //     target: _startPoint,
          //     zoom: 14.5,
          //   ),
          //   myLocationButtonEnabled: false,
          //   zoomControlsEnabled: false,
          //   polylines: {
          //     Polyline(
          //       polylineId: PolylineId("route"),
          //       points: [_startPoint, LatLng(35.518, 35.795), _endPoint], // نقاط المسار
          //       color: Colors.black,
          //       width: 4,
          //     ),
          //   },
          // ),

          // 2. صندوق معلومات الرحلة (الأعلى)
          Positioned(
            top: 80,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
                // 1. نجعل الإطار موحد اللون والسماكة ليعمل الـ borderRadius
                border: Border.all(
                  color: AppColors.main1.withOpacity(0.5),
                  width: 1,
                ),
                // 2. نستخدم الظل لمحاكاة الخط السفلي السميك (بدون بلر وبإزاحة لأسفل)
                boxShadow: [
                  BoxShadow(
                    color: AppColors.main1, // نفس لون الخط السفلي الذي تريده
                    offset: const Offset(
                      0,
                      3,
                    ), // الإزاحة لأسفل فقط (قيمة الـ 3 هي سماكة الخط)
                    blurRadius: 0, // نجعله 0 ليكون الخط حاداً وليس ضبابياً
                  ),
                  // ظل إضافي جمالي (اختياري)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 8),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TripLocationPath(
                startLocation: "مشروع شريتح شارع المكاتب",
                endLocation: "الزراعة",
                dashHeight: 30,
                startIconColor: Colors.blue, // AppColors.blue
                endIconColor: Colors.purple, // AppColors.main1
              ),
            ),
          ),

          // 3. زر "انتهت الرحلة" (الأسفل)
          Positioned(
            bottom: 40,
            left: 20,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // AppColors.main1
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              ),
              child: Text(
                "انتهت الرحلة",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 4. أيقونة التحذير (اختياري)
          Positioned(
            bottom: 30,
            right: 20,
            child: Image.asset(ImageAssets.emergency, height: 65),
          ),
        ],
      ),
    );
  }
}
