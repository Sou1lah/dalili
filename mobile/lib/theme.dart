import 'package:material_ui/material_ui.dart';

abstract final class DaliliPalette {
  static const ink = Color(0xFF0E1640);
  static const violet = Color(0xFF6D5CE8);
  static const deepViolet = Color(0xFF4B3FC4);
  static const sky = Color(0xFF5BB8FF);
  static const amber = Color(0xFFF59E0B);
}

abstract final class DaliliTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colors =
        ColorScheme.fromSeed(
          seedColor: DaliliPalette.violet,
          brightness: brightness,
        ).copyWith(
          primary: DaliliPalette.violet,
          onPrimary: Colors.white,
          secondary: DaliliPalette.sky,
          tertiary: DaliliPalette.amber,
          surface: isDark ? const Color(0xFF171B31) : Colors.white,
          onSurface: isDark ? const Color(0xFFF1F1FA) : DaliliPalette.ink,
        );
    final baseTextTheme = isDark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF101326)
          : const Color(0xFFF4F5FB),
      textTheme: baseTextTheme.apply(
        fontFamily: 'Lexend',
        fontFamilyFallback: const ['NotoSansArabic'],
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : DaliliPalette.ink.withValues(alpha: 0.07),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: DaliliPalette.violet, width: 1.5),
        ),
      ),
    );
  }
}
