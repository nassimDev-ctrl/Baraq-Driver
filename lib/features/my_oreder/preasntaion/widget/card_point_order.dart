import 'package:drever_warr/core/asset/icon_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ColumnSearch extends StatelessWidget {
  const ColumnSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.0, top: 5),
      child: Column(
        //  mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.circle, color: AppColors.main1, size: 25.sp),

          CustomPaint(size: Size(1, 40.h), painter: DashedLinePainter()),

          SvgPicture.asset(IconsAssets.locationsearch, color: AppColors.blue),
        ],
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 3, dashSpace = 3, startY = 0;
    final paint = Paint()..color = AppColors.secondary2;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
