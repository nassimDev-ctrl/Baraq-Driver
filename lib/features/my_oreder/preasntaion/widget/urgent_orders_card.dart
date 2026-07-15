import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/widgets/custom_text.dart';
import '../view/order_view.dart';

class UrgentOrdersCard extends StatelessWidget {
  final OrderButtonStatus buttonStatus;
  final String userName;
  final String phoneNumber;
  final String price;
  final String distance;
  final String fromAddress;
  final String toAddress;
  final String? date;
  final VoidCallback onAccept;

  const UrgentOrdersCard({
    super.key,
    required this.buttonStatus,
    required this.userName,
    required this.phoneNumber,
    required this.price,
    required this.distance,
    required this.fromAddress,
    required this.toAddress,
    this.date,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: const Color(0xFF9C4DB9).withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9C4DB9).withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(userName, type: AppTextType.bodySmall),
                  CustomText(phoneNumber, type: AppTextType.bodySmall),
                  SizedBox(height: 20.h),
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
                              fromAddress,
                              type: AppTextType.bodySmall,
                              maxLines: 1,
                            ),
                            SizedBox(height: 25.h),
                            CustomText(
                              toAddress,
                              type: AppTextType.bodySmall,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomText(
                      price,
                      color: Colors.cyan,
                      type: AppTextType.titleSmall,
                    ),
                    CustomText(
                      distance,
                      type: AppTextType.bodySmall,
                      color: Colors.grey,
                    ),
                    if (date != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(height: 10,),
                          CustomText(
                            "scheduled_date",
                            color: Colors.black,
                            type: AppTextType.bodySmall,
                          ),
                          CustomText(
                            date!,
                            color: Colors.black,
                            type: AppTextType.titleSmall,
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: 40.h),
                InkWell(
                  onTap: buttonStatus == OrderButtonStatus.loading
                      ? null
                      : onAccept,
                  child: _buildActionButton(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    final isLoading = buttonStatus == OrderButtonStatus.loading;
    final isAccepted = buttonStatus == OrderButtonStatus.accepted;
    final isStart = buttonStatus == OrderButtonStatus.start;

    Color backgroundColor;
    Color textColor;
    String textKey;

    if (isStart) {
      backgroundColor = const Color(0xFF9C4DB9);
      textColor = Colors.white;
      textKey = "start";
    } else if (isAccepted) {
      backgroundColor = Colors.white;
      textColor = const Color(0xFF9C4DB9);
      textKey = "accepted";
    } else {
      backgroundColor = const Color(0xFF9C4DB9);
      textColor = Colors.white;
      textKey = "accept";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: const Color(0xFF9C4DB9), width: 1.2),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: isLoading
            ? SizedBox(
          key: const ValueKey("loading"),
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: textColor,
          ),
        )
            : CustomText(
          textKey,
          key: ValueKey(textKey),
          color: textColor,
          type: AppTextType.titleSmall,
        ),
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 3, dashSpace = 2, startY = 0;
    final paint = Paint()..color = Colors.grey..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}