class MunasaknaEnvironment {
  const MunasaknaEnvironment._();

  static const String appNameAr = 'مناسكنا';
  static const String appNameEn = 'Manasikuna';
  static const String packageId = 'ps.manasikuna.app';
  static const String serviceNameEn = 'Hajj and Umrah companion';
  static const String serviceNameAr = 'تطبيق الحاج والمعتمر';
  static const String modeLabelAr = 'وضع تطوير محلي';
  static const String appScopeAr =
      'رفيق مستقل للحاج والمعتمر؛ الربط مع نسك اختياري عند اعتماده رسميًا';

  /// Development contract:
  /// No login is required until an authorized real-data provider,
  /// access controls, and platform APIs are ready.
  static const bool developmentMode = true;
  static const bool isLocalOnly = true;
  static const bool hasLogin = false;
  static const bool usesExternalDatabase = false;
  static const bool sendsPersonalData = false;
  static const bool usesExternalAnalytics = false;
  static const bool usesRealPilgrimData = false;
  static const bool persistsRawActivationToken = false;
  static const bool storesHealthNotes = false;
  static const bool nusukBackendReady = false;

  static const String developmentModeLabelAr = 'وضع التطوير: بلا تسجيل دخول';
  static const String developmentModeDescriptionAr =
      'هذه النسخة تعمل محليًا ببيانات تجريبية فقط. لا تتصل بنسك أو بقاعدة بيانات حجاج حقيقية، وأي ربط رسمي لاحق يحتاج تفويضًا ومراجعة خصوصية وأمان مستقلة.';
}
