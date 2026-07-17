import 'package:flutter/material.dart';

abstract final class NotificationsUiConstants {
  static const headerHeight = 178.0;
  static const cardRadius = 20.0;
  static const horizontalPadding = 16.0;
  static const sectionSpacing = 12.0;

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
}
