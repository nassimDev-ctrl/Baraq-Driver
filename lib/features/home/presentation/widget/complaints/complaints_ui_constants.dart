import 'package:flutter/material.dart';

abstract final class ComplaintsUiConstants {
  static const headerHeight = 220.0;
  static const bodyTopRadius = 36.0;
  static const cardRadius = 24.0;
  static const fieldRadius = 22.0;
  static const buttonHeight = 60.0;
  static const buttonRadius = 18.0;
  static const horizontalPadding = 16.0;
  static const sectionSpacing = 18.0;
  static const maxImages = 5;
  static const maxImageSizeBytes = 5 * 1024 * 1024;
  static const maxComplaintLength = 1000;

  static const softShadow = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];

  static const cardShadow = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 14,
      offset: Offset(0, 6),
    ),
  ];

  static const buttonShadow = [
    BoxShadow(
      color: Color(0x330D4EA3),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  static const uploadFill = Color(0xFFF0F6FF);
  static const uploadBorder = Color(0xFF9CB8E0);
  static const privacyFill = Color(0xFFEAF2FF);
  static const tipDivider = Color(0xFFD5DEEA);
}
