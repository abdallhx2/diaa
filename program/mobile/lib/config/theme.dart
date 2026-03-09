import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryBlue     = Color(0xFF4A90D9);
  static const Color primaryGreen    = Color(0xFF66BB6A);
  static const Color primaryOrange   = Color(0xFFFFA726);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color cardColor       = Colors.white;
  static const Color textPrimary     = Color(0xFF2C3E50);
  static const Color textSecondary   = Color(0xFF7F8C8D);
  static const Color errorColor      = Color(0xFFE57373);
  static const Color successColor    = Color(0xFF81C784);
  static const Color primaryPurple   = Color(0xFFAB8BC9);
  static const Color primaryPink     = Color(0xFFF48FB1);
  static const Color dividerColor    = Color(0xFFE0E0E0);
  static const Color shadowColor     = Color(0x1A000000);

  static const Color primaryBlue15 = Color(0x264A90D9);
  static const Color primaryBlue08 = Color(0x144A90D9);
  static const Color primaryBlue02 = Color(0x054A90D9);
  static const Color errorColor10  = Color(0x1AE57373);
  static const Color errorColor40  = Color(0x66E57373);

  static TextTheme get arabicTextTheme => GoogleFonts.cairoTextTheme();

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    primaryColor: primaryBlue,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      primary:   primaryBlue,
      secondary: primaryGreen,
      error:     errorColor,
      surface:   cardColor,
    ),
    scaffoldBackgroundColor: backgroundColor,

    textTheme: arabicTextTheme.copyWith(
      displayLarge:  GoogleFonts.cairo(fontSize: 32, fontWeight: FontWeight.bold,  color: textPrimary),
      displayMedium: GoogleFonts.cairo(fontSize: 28, fontWeight: FontWeight.bold,  color: textPrimary),
      headlineLarge: GoogleFonts.cairo(fontSize: 28, fontWeight: FontWeight.bold,  color: textPrimary),
      headlineMedium:GoogleFonts.cairo(fontSize: 24, fontWeight: FontWeight.bold,  color: textPrimary),
      headlineSmall: GoogleFonts.cairo(fontSize: 20, fontWeight: FontWeight.w600,  color: textPrimary),
      bodyLarge:     GoogleFonts.cairo(fontSize: 20, color: textPrimary),
      bodyMedium:    GoogleFonts.cairo(fontSize: 18, color: textPrimary),
      bodySmall:     GoogleFonts.cairo(fontSize: 16, color: textSecondary),
      labelLarge:    GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
      labelMedium:   GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w500, color: textSecondary),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        textStyle: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        minimumSize: const Size(double.infinity, 48),
        side: const BorderSide(color: primaryBlue, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        minimumSize: const Size(0, 48),
        textStyle: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border:            OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: dividerColor)),
      enabledBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: dividerColor)),
      focusedBorder:      OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primaryBlue, width: 2)),
      errorBorder:        OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: errorColor)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: errorColor, width: 2)),
      filled:     true,
      fillColor:  Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle:  GoogleFonts.cairo(fontSize: 16, color: textSecondary),
      labelStyle: GoogleFonts.cairo(fontSize: 16, color: textSecondary),
      errorStyle: GoogleFonts.cairo(fontSize: 14, color: errorColor),
    ),

    cardTheme: const CardThemeData(
      color:       cardColor,
      elevation:   2,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      margin: EdgeInsets.all(8),
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      elevation:   0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
      iconTheme: const IconThemeData(color: Colors.white),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor:     Colors.white,
      selectedItemColor:   primaryBlue,
      unselectedItemColor: textSecondary,
      selectedLabelStyle:   GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.cairo(fontSize: 13),
      type:      BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: backgroundColor,
      selectedColor:   primaryBlue15,
      labelStyle: GoogleFonts.cairo(fontSize: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),

    dividerTheme: const DividerThemeData(
      color:     dividerColor,
      thickness: 1,
      space:     1,
    ),

    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}