import 'package:flutter/material.dart';

abstract final class WalletUiConstants {
  static const headerHeight = 240.0;
  static const balanceCardOverlap = 88.0;
  static const balanceCardRadius = 28.0;
  static const actionCardRadius = 22.0;
  static const transactionCardRadius = 16.0;
  static const withdrawButtonHeight = 60.0;
  static const withdrawButtonRadius = 20.0;
  static const sectionSpacing = 16.0;
  static const horizontalPadding = 16.0;

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
