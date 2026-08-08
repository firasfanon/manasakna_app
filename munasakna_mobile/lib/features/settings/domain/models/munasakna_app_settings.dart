import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MunasaknaAppSettings {
  const MunasaknaAppSettings({
    required this.themeMode,
    required this.languageCode,
    required this.textScale,
    required this.enableLocationHints,
    required this.enableHajjMode,
    required this.showPrivacyBanner,
    required this.preferredRitualPath,
    required this.groupLabel,
  });

  final ThemeMode themeMode;
  final String languageCode;
  final double textScale;
  final bool enableLocationHints;
  final bool enableHajjMode;
  final bool showPrivacyBanner;
  final String preferredRitualPath;
  final String groupLabel;

  static const MunasaknaAppSettings defaults = MunasaknaAppSettings(
    themeMode: ThemeMode.system,
    languageCode: 'ar',
    textScale: 1.0,
    enableLocationHints: true,
    enableHajjMode: true,
    showPrivacyBanner: true,
    preferredRitualPath: 'hajj',
    groupLabel: 'مجموعة الحاج',
  );

  MunasaknaAppSettings copyWith({
    ThemeMode? themeMode,
    String? languageCode,
    double? textScale,
    bool? enableLocationHints,
    bool? enableHajjMode,
    bool? showPrivacyBanner,
    String? preferredRitualPath,
    String? groupLabel,
  }) {
    return MunasaknaAppSettings(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      textScale: textScale ?? this.textScale,
      enableLocationHints: enableLocationHints ?? this.enableLocationHints,
      enableHajjMode: enableHajjMode ?? this.enableHajjMode,
      showPrivacyBanner: showPrivacyBanner ?? this.showPrivacyBanner,
      preferredRitualPath: preferredRitualPath ?? this.preferredRitualPath,
      groupLabel: groupLabel ?? this.groupLabel,
    );
  }

  static MunasaknaAppSettings fromPrefs(SharedPreferences prefs) {
    ThemeMode parseThemeMode(String? value) {
      for (final mode in ThemeMode.values) {
        if (mode.name == value) return mode;
      }
      return defaults.themeMode;
    }

    return MunasaknaAppSettings(
      themeMode: parseThemeMode(prefs.getString('themeMode')),
      languageCode: prefs.getString('languageCode') ?? defaults.languageCode,
      textScale: prefs.getDouble('textScale') ?? defaults.textScale,
      enableLocationHints: prefs.getBool('enableLocationHints') ?? defaults.enableLocationHints,
      enableHajjMode: prefs.getBool('enableHajjMode') ?? defaults.enableHajjMode,
      showPrivacyBanner: prefs.getBool('showPrivacyBanner') ?? defaults.showPrivacyBanner,
      preferredRitualPath: prefs.getString('preferredRitualPath') ?? defaults.preferredRitualPath,
      groupLabel: prefs.getString('groupLabel') ?? defaults.groupLabel,
    );
  }

  Future<void> save(SharedPreferences prefs) async {
    await prefs.setString('themeMode', themeMode.name);
    await prefs.setString('languageCode', languageCode);
    await prefs.setDouble('textScale', textScale);
    await prefs.setBool('enableLocationHints', enableLocationHints);
    await prefs.setBool('enableHajjMode', enableHajjMode);
    await prefs.setBool('showPrivacyBanner', showPrivacyBanner);
    await prefs.setString('preferredRitualPath', preferredRitualPath);
    await prefs.setString('groupLabel', groupLabel);
  }
}
