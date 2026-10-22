import 'package:flutter/material.dart';

/// Centralized design tokens for consistent UI across the app
class DesignTokens {
  // Private constructor
  DesignTokens._();

  // ===========================================================================
  // COLOR TOKENS
  // ===========================================================================
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryBlueDark = Color(0xFF2563EB);
  static const Color primaryBlueLight = Color(0xFF60A5FA);
  
  static const Color primaryCyan = Color(0xFF06B6D4);
  static const Color primaryCyanDark = Color(0xFF0891B2);
  static const Color primaryCyanLight = Color(0xFF22D3EE);
  
  static const Color amber = Color(0xFFF59E0B);
  static const Color amberLight = Color(0xFFFBBF24);
  static const Color amberDark = Color(0xFFD97706);
  
  static const Color emerald = Color(0xFF10B981);
  static const Color emeraldLight = Color(0xFF34D399);
  static const Color emeraldDark = Color(0xFF059669);
  
  static const Color red = Color(0xFFEF4444);
  static const Color redLight = Color(0xFFF87171);
  static const Color redDark = Color(0xFFDC2626);
  
  static const Color purple = Color(0xFF8B5CF6);
  static const Color purpleLight = Color(0xFFA78BFA);
  static const Color purpleDark = Color(0xFF7C3AED);

  // Surface colors for dark theme
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceDarkElevated = Color(0xFF334155);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color backgroundDarkSecondary = Color(0xFF1E293B);
  
  // Surface colors for light theme
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceLightElevated = Color(0xFFF8FAFC);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundLightSecondary = Color(0xFFF1F5F9);

  // Text colors
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);
  static const Color textOnPrimaryDark = Color(0xFF0F172A);
  
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textTertiaryLight = Color(0xFF94A3B8);
  static const Color textOnPrimaryLight = Colors.white;

  // Border colors
  static const Color borderDark = Color(0xFF334155);
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderSubtleDark = Color(0xFF1E293B);
  static const Color borderSubtleLight = Color(0xFFF1F5F9);

  // ===========================================================================
  // SPACING TOKENS
  // ===========================================================================
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 12.0;
  static const double spacingLg = 16.0;
  static const double spacingXl = 20.0;
  static const double spacing2xl = 24.0;
  static const double spacing3xl = 32.0;
  static const double spacing4xl = 40.0;

  // Page margins
  static const double pageMargin = 16.0;
  static const double pageMarginLarge = 20.0;

  // Component spacing
  static const double cardPadding = 16.0;
  static const double cardPaddingLarge = 20.0;
  static const double sectionGap = 24.0;
  static const double componentGap = 12.0;

  // ===========================================================================
  // BORDER RADIUS TOKENS
  // ===========================================================================
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radius2xl = 24.0;
  static const double radiusFull = 9999.0;

  // ===========================================================================
  // ELEVATION/SHADOW TOKENS
  // ===========================================================================
  static const List<BoxShadow> shadowSubtle = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> shadowCard = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadowCardElevated = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowColored(Color color, {double alpha = 0.15}) => [
    BoxShadow(
      color: color.withValues(alpha: alpha),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // ===========================================================================
  // TYPOGRAPHY TOKENS
  // ===========================================================================
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.3,
  );

  static const TextStyle headline3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.2,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static const TextStyle numberLarge = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -0.5,
  );

  static const TextStyle numberMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -0.3,
  );

  static const TextStyle numberSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  // ===========================================================================
  // ANIMATION TOKENS
  // ===========================================================================
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 250);
  static const Duration animationSlow = Duration(milliseconds: 350);

  static const Curve curveDefault = Curves.easeInOut;
  static const Curve curveSpring = Curves.elasticOut;

  // ===========================================================================
  // TOUCH TARGETS
  // ===========================================================================
  static const double minTouchTarget = 48.0;
  static const double minTouchTargetSmall = 44.0;

  // ===========================================================================
  // HELPER METHODS
  // ===========================================================================
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).cardTheme.color ?? 
           (Theme.of(context).brightness == Brightness.dark ? surfaceDark : surfaceLight);
  }

  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }

  static Color getTextPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? textPrimaryDark : textPrimaryLight;
  }

  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? textSecondaryDark : textSecondaryLight;
  }

  static Color getTextTertiary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? textTertiaryDark : textTertiaryLight;
  }

  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? borderDark : borderLight;
  }

  static Color getBorderSubtle(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? borderSubtleDark : borderSubtleLight;
  }

  static List<BoxShadow> getCardShadow(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? shadowCardElevated : shadowCard;
  }

  static Color getPrimaryAccent(BuildContext context) {
    return Theme.of(context).colorScheme.primary;
  }
}

/// Semantic color extensions for status indicators
extension StatusColors on Color {
  static Color get success => DesignTokens.emerald;
  static Color get warning => DesignTokens.amber;
  static Color get error => DesignTokens.red;
  static Color get info => DesignTokens.primaryBlue;
}

/// Extension for consistent text styles with color
extension TextStyleExtensions on TextStyle {
  TextStyle withPrimaryColor(BuildContext context) {
    return copyWith(color: DesignTokens.getTextPrimary(context));
  }

  TextStyle withSecondaryColor(BuildContext context) {
    return copyWith(color: DesignTokens.getTextSecondary(context));
  }

  TextStyle withTertiaryColor(BuildContext context) {
    return copyWith(color: DesignTokens.getTextTertiary(context));
  }

  TextStyle withColor(Color color) {
    return copyWith(color: color);
  }
}