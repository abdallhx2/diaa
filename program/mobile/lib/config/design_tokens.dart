import 'package:flutter/material.dart';

export 'package:edu_smart_assistant/config/theme.dart';

class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 28;
  static const double xxl = 40;
}

class AppRadius {
  AppRadius._();
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 18;
  static const double full = 999;
}

class AppShadow {
  AppShadow._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x148B5FBF),
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x268B5FBF),
      blurRadius: 32,
      offset: Offset(0, 8),
    ),
  ];
}

