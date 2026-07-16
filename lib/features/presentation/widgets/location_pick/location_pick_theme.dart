import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class LocationPickTheme {
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  static BorderRadius get radius28 => BorderRadius.circular(28.r);
  static BorderRadius get radius24 => BorderRadius.circular(24.r);
  static BorderRadius get radius20 => BorderRadius.circular(20.r);

  static BorderRadius get sheetTopRadius => BorderRadius.vertical(
        top: Radius.circular(32.r),
      );

  static const Color textPrimary = Color(0xFF1A2B49);
  static const Color textSecondary = Color(0xFF8E97A8);
  static const Color gpsBlue = Color(0xFF4A90D9);
  static const Color signalGreen = Color(0xFF34C759);
  static const Color signalGreenBg = Color(0xFFE8F8EC);
}
