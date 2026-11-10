import 'package:flutter/material.dart';

/// High-contrast minimal fintech theme definition.
/// Characterized by solid stark whites, deep obsidian blacks, crisp borders,
/// and flat geometry with no glassmorphism, blurs, or gradients.
class AppTheme {
  // Monochromatic high-contrast fintech palette
  static const Color background = Color(0xFFF7F8FA);     // Crisp light gray canvas
  static const Color surface = Color(0xFFFFFFFF);        // Stark pure white
  static const Color surfaceVariant = Color(0xFFF1F3F5); // Flat light neutral
  
  static const Color textPrimary = Color(0xFF111827);    // Deep black / obsidian
  static const Color textSecondary = Color(0xFF6B7280);  // Neutral slate gray
  static const Color textTertiary = Color(0xFF9CA3AF);   // Soft neutral caption
  
  static const Color primary = Color(0xFF0F172A);        // Deep ink black for primary CTA
  static const Color accent = Color(0xFF2563EB);         // Focused fintech blue accent
  static const Color divider = Color(0xFFE5E7EB);        // Crisp 1px border/divider
  static const Color border = Color(0xFFE2E8F0);         // Structural card border
  
  static const Color success = Color(0xFF059669);        // Emerald green for active/repaid
  static const Color successLight = Color(0xFFECFDF5);   // Subtle green pill background
  
  static const Color warning = Color(0xFFD97706);        // Amber for review/pending
  static const Color warningLight = Color(0xFFFFFBEB);   // Subtle amber pill background
  
  static const Color danger = Color(0xFFDC2626);         // Crimson red for overdue/delete
  static const Color dangerLight = Color(0xFFFEF2F2);    // Subtle red pill background

  // Compatibility shims for legacy glassmorphism references
  static const Color glassWhite = Color(0xFFFFFFFF);
  static const Color glassBorder = Color(0xFFE5E7EB);
  static const Color glassShadow = Color(0x0A000000);
  static const Color glassHighlight = Color(0xFFFFFFFF);

  static const String fontFamily = 'Calibri';

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: surface,
        error: danger,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      dividerColor: divider,
      cardColor: surface,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
          fontSize: 32,
        ),
        displayMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          fontSize: 24,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          fontSize: 20,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          fontSize: 17,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w400,
          fontSize: 15,
          letterSpacing: -0.1,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontWeight: FontWeight.w400,
          fontSize: 13,
          letterSpacing: 0,
        ),
        labelLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          fontSize: 13,
        ),
        labelSmall: TextStyle(
          color: textSecondary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          fontSize: 10,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: textPrimary, size: 22),
        actionsIconTheme: IconThemeData(color: textPrimary, size: 22),
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          color: textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      useMaterial3: true,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }
}
