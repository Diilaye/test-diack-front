import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Extensions utiles pour faciliter l'utilisation du thème
extension AppThemeExtensions on BuildContext {
  /// Accès rapide aux couleurs du thème
  Color get primaryColor => AppTheme.primaryColor;
  Color get secondaryColor => AppTheme.secondaryColor;
  Color get accentColor => AppTheme.accentColor;
  Color get backgroundColor => AppTheme.backgroundColor;
  Color get surfaceColor => AppTheme.surfaceColor;
  Color get textPrimary => AppTheme.textPrimary;
  Color get textSecondary => AppTheme.textSecondary;

  /// Accès aux gradients
  LinearGradient get primaryGradient => AppTheme.primaryGradient;
  LinearGradient get secondaryGradient => AppTheme.secondaryGradient;
  LinearGradient get accentGradient => AppTheme.accentGradient;

  /// Accès aux décorations communes
  BoxDecoration get primaryContainer => AppTheme.primaryContainer;
  BoxDecoration get secondaryContainer => AppTheme.secondaryContainer;
  BoxDecoration get accentContainer => AppTheme.accentContainer;
  BoxDecoration get glassMorphism => AppTheme.glassMorphism;

  /// Accès aux ombres
  List<BoxShadow> get cardShadow => AppTheme.cardShadow;
}

/// Widgets de composants personnalisés utilisant le thème
class ThemedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isPrimary;
  final bool isOutlined;

  const ThemedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isPrimary = true,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
        label: Text(text),
        style: OutlinedButton.styleFrom(
          foregroundColor:
              isPrimary ? AppTheme.primaryColor : AppTheme.secondaryColor,
          side: BorderSide(
            color: isPrimary ? AppTheme.primaryColor : AppTheme.secondaryColor,
          ),
        ),
      );
    }

    return Container(
      decoration:
          isPrimary ? AppTheme.primaryContainer : AppTheme.secondaryContainer,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Icon(icon, color: AppTheme.textOnPrimary)
            : const SizedBox.shrink(),
        label: Text(
          text,
          style: TextStyle(color: AppTheme.textOnPrimary),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }
}

class ThemedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool hasGradient;
  final Color? customColor;

  const ThemedCard({
    super.key,
    required this.child,
    this.padding,
    this.hasGradient = false,
    this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(16),
      decoration: hasGradient
          ? AppTheme.primaryContainer
          : BoxDecoration(
              color: customColor ?? AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: AppTheme.cardShadow,
              border: Border.all(
                color: Colors.grey.shade200,
                width: 1,
              ),
            ),
      child: child,
    );
  }
}

class ThemedIconContainer extends StatelessWidget {
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final bool hasGradient;

  const ThemedIconContainer({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.iconColor,
    this.size = 48,
    this.hasGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: hasGradient
          ? AppTheme.primaryContainer
          : BoxDecoration(
              color: backgroundColor ?? AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
      child: Icon(
        icon,
        color: iconColor ??
            (hasGradient ? AppTheme.textOnPrimary : AppTheme.primaryColor),
        size: size * 0.5,
      ),
    );
  }
}
