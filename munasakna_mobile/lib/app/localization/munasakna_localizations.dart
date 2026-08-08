import 'package:flutter/widgets.dart';

class MunasaknaLocalizations {
  const MunasaknaLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<MunasaknaLocalizations> delegate =
      _MunasaknaLocalizationsDelegate();

  static MunasaknaLocalizations of(BuildContext context) {
    return Localizations.of<MunasaknaLocalizations>(
          context,
          MunasaknaLocalizations,
        ) ??
        const MunasaknaLocalizations(Locale('ar'));
  }

  String get appName => locale.languageCode == 'ar' ? 'مناسكنا' : 'Manasikuna';
}

class _MunasaknaLocalizationsDelegate
    extends LocalizationsDelegate<MunasaknaLocalizations> {
  const _MunasaknaLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<MunasaknaLocalizations> load(Locale locale) async {
    return MunasaknaLocalizations(locale);
  }

  @override
  bool shouldReload(_MunasaknaLocalizationsDelegate old) => false;
}
