import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // -------- Color palette (from CSS :root) --------
  static const Color primary100 = Color(0xFF8B5FBF); // light purple
  static const Color primary200 = Color(0xFF61398F); // dark purple
  static const Color accent100 = Color(0xFFD6C6E1); // light lavender
  static const Color accent200 = Color(0xFF9A73B5); // medium purple
  static const Color text100 = Color(0xFF4A4A4A); // primary text
  static const Color text200 = Color(0xFF878787); // secondary text
  static const Color bg100 = Color(0xFFF5F3F7); // main background
  static const Color bg200 = Color(0xFFE9E4ED); // secondary background
  static const Color bg300 = Color(0xFFFFFFFF); // white / cards
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFE53935);

  // -------- Backward-compat aliases (old blue theme) --------
  static const Color primaryBlue = primary200;
  static const Color secondaryOrange = accent200;
  static const Color backgroundColor = bg100;
  static const Color primaryGreen = successColor;
  static const Color cardColor = bg300;
  static const Color textPrimary = text100;
  static const Color textSecondary = text200;

  // -------- Design constants --------
  static const double radius = 18.0;
  static const double radiusSm = 12.0;

  static const BoxShadow shadow = BoxShadow(
    color: Color(0x268B5FBF),
    blurRadius: 32,
    offset: Offset(0, 8),
  );

  static const BoxShadow shadowLg = BoxShadow(
    color: Color(0x3861398F),
    blurRadius: 48,
    offset: Offset(0, 16),
  );

  // -------- Text theme (Tajawal) --------
  static TextTheme get _arabicTextTheme => GoogleFonts.tajawalTextTheme();

  // -------- Light theme --------
  static ThemeData get lightTheme => ThemeData(
        primaryColor: primary100,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary100,
          secondary: accent200,
          error: errorColor,
          surface: bg300,
        ),
        scaffoldBackgroundColor: bg100,
        textTheme: _arabicTextTheme.copyWith(
          headlineLarge: GoogleFonts.tajawal(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: text100,
          ),
          headlineMedium: GoogleFonts.tajawal(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: text100,
          ),
          bodyLarge: GoogleFonts.tajawal(
            fontSize: 16,
            color: text100,
          ),
          bodyMedium: GoogleFonts.tajawal(
            fontSize: 14,
            color: text100,
          ),
          labelLarge: GoogleFonts.tajawal(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: text100,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusSm),
            ),
            backgroundColor: primary200,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            elevation: 0,
            shadowColor: const Color(0x668B5FBF),
            textStyle: GoogleFonts.tajawal(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ).copyWith(
            elevation: WidgetStateProperty.all(0),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: bg100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusSm),
            borderSide: const BorderSide(color: bg200, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusSm),
            borderSide: const BorderSide(color: bg200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusSm),
            borderSide: const BorderSide(color: primary100, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          margin: const EdgeInsets.all(8),
          color: bg300,
          shadowColor: Colors.transparent,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: bg300,
          foregroundColor: text100,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.tajawal(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: text100,
          ),
        ),
      );
}
