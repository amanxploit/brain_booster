import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryLight = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF818CF8);
  static const Color secondaryLight = Color(0xFF06B6D4);
  static const Color secondaryDark = Color(0xFF22D3EE);
  static const Color accentLight = Color(0xFFF59E0B);
  static const Color accentDark = Color(0xFFFBBF24);
  static const Color successLight = Color(0xFF10B981);
  static const Color successDark = Color(0xFF34D399);
  static const Color errorLight = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFF87171);

  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryLight,
      secondary: secondaryLight,
      tertiary: accentLight,
      surface: surfaceLight,
      background: backgroundLight,
      error: errorLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1E293B),
      onBackground: Color(0xFF1E293B),
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: backgroundLight,
    cardTheme: CardThemeData(
      color: surfaceLight,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: primaryLight.withOpacity(0.3),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLight,
        side: const BorderSide(color: primaryLight, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryLight, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorLight, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(color: Colors.grey.shade600),
      hintStyle: TextStyle(color: Colors.grey.shade400),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceLight,
      foregroundColor: Color(0xFF1E293B),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFF1E293B),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: Color(0xFF1E293B)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: primaryLight,
      unselectedItemColor: Color(0xFF94A3B8),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: primaryLight,
      unselectedLabelColor: Color(0xFF94A3B8),
      indicatorColor: primaryLight,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: primaryLight.withOpacity(0.1),
      selectedColor: primaryLight,
      disabledColor: Colors.grey.shade200,
      labelStyle: const TextStyle(color: primaryLight, fontWeight: FontWeight.w500),
      secondaryLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade200,
      thickness: 1,
      space: 1,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w700, color: Color(0xFF1E293B), letterSpacing: -0.25),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFF334155)),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF475569)),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF64748B)),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF475569)),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryDark,
      secondary: secondaryDark,
      tertiary: accentDark,
      surface: surfaceDark,
      background: backgroundDark,
      error: errorDark,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFFF1F5F9),
      onBackground: Color(0xFFF1F5F9),
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: backgroundDark,
    cardTheme: CardThemeData(
      color: surfaceDark,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        elevation: 3,
        shadowColor: primaryDark.withOpacity(0.4),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryDark,
        side: const BorderSide(color: primaryDark, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryDark, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorDark, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(color: Colors.grey.shade400),
      hintStyle: TextStyle(color: Colors.grey.shade600),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceDark,
      foregroundColor: Color(0xFFF1F5F9),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFFF1F5F9),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: Color(0xFFF1F5F9)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: primaryDark,
      unselectedItemColor: Color(0xFF64748B),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: primaryDark,
      unselectedLabelColor: Color(0xFF64748B),
      indicatorColor: primaryDark,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: primaryDark.withOpacity(0.2),
      selectedColor: primaryDark,
      disabledColor: Colors.grey.shade800,
      labelStyle: const TextStyle(color: primaryDark, fontWeight: FontWeight.w500),
      secondaryLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade700,
      thickness: 1,
      space: 1,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w700, color: Color(0xFFF1F5F9), letterSpacing: -0.25),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w700, color: Color(0xFFF1F5F9)),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Color(0xFFF1F5F9)),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Color(0xFFF1F5F9)),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFFF1F5F9)),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFFF1F5F9)),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Color(0xFFE2E8F0)),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFFCBD5E1)),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xFF94A3B8)),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFFF1F5F9)),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFFCBD5E1)),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8)),
    ),
  );
}