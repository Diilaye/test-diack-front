import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';

/// Composants personnalisés pour l'interface professionnelle
class ProfessionalComponents {
  /// Crée un conteneur avec effet glassmorphism
  static Widget buildGlassMorphismContainer({
    required Widget child,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
    double opacity = 0.1,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor.withOpacity(opacity),
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  /// Crée un bouton avec gradient professionnel
  static Widget buildGradientButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    bool isSecondary = false,
    EdgeInsets? padding,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient:
            isSecondary ? AppTheme.secondaryGradient : AppTheme.primaryGradient,
        boxShadow: [
          BoxShadow(
            color:
                (isSecondary ? AppTheme.secondaryColor : AppTheme.primaryColor)
                    .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Icon(icon, color: AppTheme.textOnPrimary, size: 20)
            : const SizedBox.shrink(),
        label: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textOnPrimary,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  /// Crée une carte de fonctionnalité professionnelle
  static Widget buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    Color? accentColor,
    bool isHighlighted = false,
  }) {
    final color = accentColor ?? AppTheme.primaryColor;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlighted
              ? color.withOpacity(0.2)
              : AppTheme.primaryColor.withOpacity(0.05),
          width: isHighlighted ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(isHighlighted ? 0.15 : 0.08),
            blurRadius: isHighlighted ? 25 : 20,
            offset: const Offset(0, 8),
          ),
          if (isHighlighted)
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 40,
              offset: const Offset(0, 20),
              spreadRadius: -5,
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: AppTheme.textOnPrimary,
              size: 28,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  /// Crée un badge de statut professionnel
  static Widget buildStatusBadge({
    required String text,
    required IconData icon,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final bgColor = backgroundColor ?? AppTheme.successColor;
    final txtColor = textColor ?? AppTheme.textOnPrimary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: bgColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: bgColor,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: bgColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Crée un conteneur avec animation de hover
  static Widget buildHoverContainer({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsets? padding,
    BorderRadius? borderRadius,
  }) {
    return MouseRegion(
      cursor:
          onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
