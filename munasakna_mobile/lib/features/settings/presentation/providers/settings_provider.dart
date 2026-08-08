import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/munasakna_app_settings.dart';

final appSettingsControllerProvider = AsyncNotifierProvider<AppSettingsController, MunasaknaAppSettings>(
  AppSettingsController.new,
);

class AppSettingsController extends AsyncNotifier<MunasaknaAppSettings> {
  SharedPreferences? _prefs;

  Future<SharedPreferences> _loadPrefs() async {
    final cached = _prefs;
    if (cached != null) return cached;
    final prefs = await SharedPreferences.getInstance();
    _prefs = prefs;
    return prefs;
  }

  @override
  Future<MunasaknaAppSettings> build() async {
    final prefs = await _loadPrefs();
    return MunasaknaAppSettings.fromPrefs(prefs);
  }

  Future<void> persistSettings(MunasaknaAppSettings settings) async {
    state = AsyncData(settings);
    final prefs = await _loadPrefs();
    await settings.save(prefs);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    await persistSettings((state.value ?? MunasaknaAppSettings.defaults).copyWith(themeMode: themeMode));
  }

  Future<void> setLanguageCode(String languageCode) async {
    await persistSettings((state.value ?? MunasaknaAppSettings.defaults).copyWith(languageCode: languageCode));
  }

  Future<void> setTextScale(double textScale) async {
    await persistSettings((state.value ?? MunasaknaAppSettings.defaults).copyWith(textScale: textScale));
  }

  Future<void> setLocationHints(bool value) async {
    await persistSettings((state.value ?? MunasaknaAppSettings.defaults).copyWith(enableLocationHints: value));
  }

  Future<void> setHajjMode(bool value) async {
    await persistSettings((state.value ?? MunasaknaAppSettings.defaults).copyWith(enableHajjMode: value));
  }

  Future<void> setPrivacyBanner(bool value) async {
    await persistSettings((state.value ?? MunasaknaAppSettings.defaults).copyWith(showPrivacyBanner: value));
  }

  Future<void> setPreferredRitualPath(String value) async {
    await persistSettings((state.value ?? MunasaknaAppSettings.defaults).copyWith(preferredRitualPath: value));
  }

  Future<void> setGroupLabel(String value) async {
    await persistSettings((state.value ?? MunasaknaAppSettings.defaults).copyWith(groupLabel: value));
  }

  Future<void> reset() async {
    await persistSettings(MunasaknaAppSettings.defaults);
  }
}
