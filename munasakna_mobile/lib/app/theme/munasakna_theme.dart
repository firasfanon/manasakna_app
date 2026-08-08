import 'package:flutter/material.dart';

class MunasaknaTheme {
  const MunasaknaTheme._();

  static const Color haramGreen = Color(0xFF0B5D4B);
  static const Color deepHaramGreen = Color(0xFF073B31);
  static const Color zamzamBlue = Color(0xFF0E7490);
  static const Color kaabaBlack = Color(0xFF111827);
  static const Color kiswahGold = Color(0xFFD6A83B);
  static const Color warmGold = Color(0xFFE7C66A);
  static const Color ihramIvory = Color(0xFFFBF7EA);
  static const Color desertSand = Color(0xFFEAD8B8);
  static const Color roseAlert = Color(0xFFB42318);
  static const Color darkBackground = Color(0xFF06120F);
  static const Color darkCard = Color(0xFF10201B);

  static LinearGradient sacredGradient(ColorScheme scheme) => LinearGradient(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        colors: [
          scheme.primary,
          deepHaramGreen,
          kaabaBlack,
        ],
      );

  static LinearGradient goldMistGradient(ColorScheme scheme) => LinearGradient(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        colors: [
          kiswahGold.withValues(alpha: 0.22),
          scheme.primary.withValues(alpha: 0.10),
          scheme.surface,
        ],
      );

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: haramGreen,
      primary: haramGreen,
      secondary: kiswahGold,
      tertiary: zamzamBlue,
      error: roseAlert,
      surface: Colors.white,
      brightness: Brightness.light,
    );
    return _base(scheme).copyWith(
      scaffoldBackgroundColor: ihramIvory,
      cardColor: Colors.white,
      navigationBarTheme: _navigationBarTheme(scheme),
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: haramGreen,
      primary: const Color(0xFF6EE7B7),
      secondary: warmGold,
      tertiary: const Color(0xFF67E8F9),
      error: const Color(0xFFFFB4AB),
      surface: darkCard,
      brightness: Brightness.dark,
    );
    return _base(scheme).copyWith(
      scaffoldBackgroundColor: darkBackground,
      cardColor: darkCard,
      navigationBarTheme: _navigationBarTheme(scheme),
    );
  }

  static ThemeData _base(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'NotoSansArabic',
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shadowColor: scheme.shadow.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(26),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.48)),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.55)),
        selectedColor: scheme.primaryContainer.withValues(alpha: 0.75),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: scheme.primary, width: 1.4),
        ),
        filled: true,
        fillColor: scheme.surfaceContainerHighest.withValues(alpha: 0.38),
      ),
      listTileTheme: const ListTileThemeData(contentPadding: EdgeInsets.zero),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant.withValues(alpha: 0.60)),
    );
  }

  static NavigationBarThemeData _navigationBarTheme(ColorScheme scheme) {
    return NavigationBarThemeData(
      height: 76,
      elevation: 0,
      backgroundColor: scheme.surface.withValues(alpha: 0.96),
      indicatorColor: scheme.secondaryContainer.withValues(alpha: 0.72),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return TextStyle(
          fontSize: 11,
          fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
          color: selected ? scheme.primary : scheme.onSurfaceVariant,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? scheme.primary : scheme.onSurfaceVariant,
          size: selected ? 25 : 23,
        );
      }),
    );
  }
}
