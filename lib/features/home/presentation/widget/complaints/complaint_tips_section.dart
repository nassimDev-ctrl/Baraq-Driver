import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_ui_constants.dart';
import 'package:drever_warr/features/home/presentation/widget/complaints/complaints_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComplaintTipsSection extends StatelessWidget {
  const ComplaintTipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = [
      TipCardData(
        icon: Icons.description_outlined,
        color: AppColors.main1,
        titleKey: 'complaint_tip_details_title',
        subtitleKey: 'complaint_tip_details_subtitle',
      ),
      TipCardData(
        icon: Icons.photo_camera_outlined,
        color: AppColors.button,
        titleKey: 'complaint_tip_photo_title',
        subtitleKey: 'complaint_tip_photo_subtitle',
      ),
      TipCardData(
        icon: Icons.schedule_rounded,
        color: AppColors.accentOrange,
        titleKey: 'complaint_tip_response_title',
        subtitleKey: 'complaint_tip_response_subtitle',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.lightbulb_outline_rounded,
              size: 18.sp,
              color: const Color(0xFFF59E0B),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: Text(
                AppTranslations.getText(context, 'complaint_tips_title'),
                style: TextStyle(
                  color: AuthUiConstants.textPrimary,
                  fontSize: 14.5.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(ComplaintsUiConstants.cardRadius.r),
            boxShadow: ComplaintsUiConstants.cardShadow,
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < tips.length; i++) ...[
                  if (i > 0)
                    CustomPaint(
                      size: Size(1.w, double.infinity),
                      painter: _DashedVerticalPainter(
                        color: ComplaintsUiConstants.tipDivider,
                      ),
                    ),
                  Expanded(child: TipCard(data: tips[i])),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TipCardData {
  const TipCardData({
    required this.icon,
    required this.color,
    required this.titleKey,
    required this.subtitleKey,
  });

  final IconData icon;
  final Color color;
  final String titleKey;
  final String subtitleKey;
}

class TipCard extends StatelessWidget {
  const TipCard({super.key, required this.data});

  final TipCardData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, color: data.color, size: 20.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            AppTranslations.getText(context, data.titleKey),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AuthUiConstants.textPrimary,
              fontSize: 11.5.sp,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            AppTranslations.getText(context, data.subtitleKey),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AuthUiConstants.mutedText,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w500,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedVerticalPainter extends CustomPainter {
  _DashedVerticalPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2;

    const dash = 4.0;
    const gap = 3.0;
    var y = 0.0;
    final x = size.width / 2;
    while (y < size.height) {
      canvas.drawLine(Offset(x, y), Offset(x, y + dash), paint);
      y += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedVerticalPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
