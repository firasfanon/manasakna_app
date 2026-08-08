import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/domain/models/munasakna_app_settings.dart';
import '../features/settings/presentation/providers/settings_provider.dart';
import 'localization/munasakna_localizations.dart';
import 'router/munasakna_router.dart';
import 'theme/munasakna_theme.dart';

class MunasaknaApp extends ConsumerWidget {
  const MunasaknaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsControllerProvider);
    final settings = settingsAsync.value ?? MunasaknaAppSettings.defaults;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'مناسكنا',
      theme: MunasaknaTheme.light(),
      darkTheme: MunasaknaTheme.dark(),
      themeMode: settings.themeMode,
      routerConfig: munasaknaRouter,
      locale: Locale(settings.languageCode),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        MunasaknaLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      builder: (context, child) {
        final locale = Localizations.localeOf(context);
        final direction = locale.languageCode == 'ar' ? TextDirection.rtl : TextDirection.ltr;
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: TextScaler.linear(settings.textScale)),
          child: Directionality(textDirection: direction, child: child ?? const SizedBox.shrink()),
        );
      },
    );
  }
}
