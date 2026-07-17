import 'package:drever_warr/core/asset/image_asset.dart';
import 'package:drever_warr/core/constant/app_colors.dart';
import 'package:drever_warr/core/constant/app_spacing.dart';
import 'package:drever_warr/core/translate/app_translate.dart';
import 'package:drever_warr/core/widgets/auth/auth_gradient_header.dart';
import 'package:drever_warr/features/my_tripe/presentation/widget/trips/trips_ui_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TripsHeader extends StatelessWidget {
  const TripsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthGradientHeader(
      height: TripsUiConstants.headerHeight,
      backgroundImage: ImageAssets.taxiWebp,
      backgroundFit: BoxFit.contain,
      backgroundAlignment: Alignment.centerLeft,
      mapOpacity: 0.72,
      overlayTopAlpha: 0.1,
      overlayBottomAlpha: 0.42,
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            PositionedDirectional(
              start: AppSpacing.md.w,
              top: AppSpacing.md.h,
              child: Material(
                color: Colors.white.withValues(alpha: 0.16),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.maybePop(context),
                  child: SizedBox(
                    width: 42.r,
                    height: 42.r,
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 18.w,
              left: 140.w,
              bottom: 48.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    AppTranslations.getText(context, 'my_trips'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.15,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    AppTranslations.getText(context, 'my_trips_subtitle'),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontSize: 12.5.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: AppColors.button,
                        size: 18.sp,
                      ),
                      Expanded(
                        child: CustomPaint(
                          painter: _DashedRoutePainter(
                            color: AppColors.accentOrange.withValues(alpha: 0.9),
                          ),
                          child: SizedBox(height: 2.h),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedRoutePainter extends CustomPainter {
  _DashedRoutePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double startX = 0;
    final y = size.height / 2;
    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, y),
        Offset((startX + dashWidth).clamp(0, size.width), y),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoutePainter oldDelegate) =>
      oldDelegate.color != color;
}
