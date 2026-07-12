import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors (FFLIPY Style)
  static const Color lightPrimary = Color(0xFF007AFF);
  static const Color lightSecondary = Color(0xFF0EA5E9);
  static const Color lightAccent = Color(0xFFEC4899);
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightError = Color(0xFFDC2626);
  static const Color lightErrorContainer = Color(0xFFFFE5E0);
  static const Color lightSuccess = Color(0xFF6BA180);
  static const Color lightWarning = Color(0xFFF59E0B);
  static const Color lightInfo = Color(0xFF0EA5E9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color topBar = Color(0x4827A18D);
  static const Color actionBar = Color(0xFFE91E63);
  static const Color topBarGradientLeft = Color(0xFFF3BED9);
  static const Color topBarGradientRight = Color(0xFF39D1B8);

  // Neutral Colors
  static const Color neutralGrey50 = Color(0xFFFAFAFA);
  static const Color neutralGrey100 = Color(0xFFF3F4F6);
  static const Color neutralGrey200 = Color(0xFFE5E7EB);
  static const Color neutralGrey300 = Color(0xFFD1D5DB);
  static const Color neutralGrey400 = Color(0xFF9CA3AF);
  static const Color neutralGrey500 = Color(0xFF6B7280);
  static const Color neutralGrey600 = Color(0xFF4B5563);
  static const Color neutralGrey700 = Color(0xFF374151);
  static const Color neutralGrey800 = Color(0xFF1F2937);
  static const Color neutralGrey900 = Color(0xFF111827);

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        secondary: lightSecondary,
        tertiary: lightAccent,
        surface: lightSurface,
        error: lightError,
        errorContainer: lightErrorContainer,
      ),
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: neutralGrey900,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      textTheme: TextTheme(
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: neutralGrey700,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: neutralGrey600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: neutralGrey100),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: neutralGrey50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: neutralGrey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: neutralGrey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightError),
        ),
        labelStyle: GoogleFonts.poppins(color: neutralGrey600, fontSize: 14),
        hintStyle: GoogleFonts.poppins(color: neutralGrey400, fontSize: 14),
      ),
    );
  }
}

extension ColorSchemeExtension on ColorScheme {
  Color get success => AppTheme.lightSuccess;
  Color get warning => AppTheme.lightWarning;
  Color get info => AppTheme.lightInfo;
  Color get topBarGradientLeft => AppTheme.topBarGradientLeft;
  Color get topBarGradientRight => AppTheme.topBarGradientRight;
  Color get topBar => AppTheme.topBar;
  Color get actionBar => AppTheme.actionBar;
}
