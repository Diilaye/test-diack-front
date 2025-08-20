import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 3 Couleurs de base du thème
  static const Color primaryColor = Color(0xFFE40046); // Bleu principal
  static const Color secondaryColor = Color(0xFF00313C); // Vert secondaire
  static const Color accentColor = Color(0xFFE40046); // Violet accent

  // Couleurs dérivées
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFDC2626);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color successColor = secondaryColor;

  // Couleurs de texte
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Couleurs avec opacité
  static Color get primaryLight => primaryColor.withOpacity(0.1);
  static Color get secondaryLight => secondaryColor.withOpacity(0.1);
  static Color get accentLight => accentColor.withOpacity(0.1);

  // Gradient principal
  static LinearGradient get primaryGradient => LinearGradient(
        colors: [primaryColor, primaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // Gradient secondaire
  static LinearGradient get secondaryGradient => LinearGradient(
        colors: [secondaryColor, secondaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // Gradient d'accent
  static LinearGradient get accentGradient => LinearGradient(
        colors: [accentColor, primaryColor],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // ThemeData pour l'application
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
        onPrimary: textOnPrimary,
        onSecondary: textOnPrimary,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),

      // Configuration des textes
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -1,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
      ),

      // Configuration des boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textOnPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Configuration des cartes
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),

      // Configuration de l'AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimary,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
      ),
    );
  }

  // Méthodes utilitaires pour les ombres
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: primaryColor.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> elevatedShadow(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.3),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ];

  // Méthodes pour créer des conteneurs avec style
  static BoxDecoration get primaryContainer => BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: elevatedShadow(primaryColor),
      );

  static BoxDecoration get secondaryContainer => BoxDecoration(
        gradient: secondaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: elevatedShadow(secondaryColor),
      );

  static BoxDecoration get accentContainer => BoxDecoration(
        gradient: accentGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: elevatedShadow(accentColor),
      );

  static BoxDecoration get glassMorphism => BoxDecoration(
        color: surfaceColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      );
}
