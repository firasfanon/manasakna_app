class MunasaknaEnvironment {
  const MunasaknaEnvironment._();

  static const String appNameAr = 'مناسكنا';
  static const String appNameEn = 'Manasikuna';
  static const String packageId = 'ps.manasikuna.app';
  static const String serviceNameEn = 'Hajj and Umrah companion';
  static const String serviceNameAr = 'تطبيق الحاج والمعتمر';
  static const String modeLabelAr = 'وضع تطوير محلي';
  static const String appScopeAr = 'خدمات الحج والعمرة تحت نظام نسك';

  /// Development contract:
  /// No login is required until the Nusuk database, RLS, and platform APIs are ready.
  static const bool developmentMode = true;
  static const bool isLocalOnly = true;
  static const bool hasLogin = false;
  static const bool usesExternalDatabase = false;
  static const bool sendsPersonalData = false;
  static const bool nusukBackendReady = false;

  static const String developmentModeLabelAr = 'وضع التطوير: بلا تسجيل دخول';
  static const String developmentModeDescriptionAr =
      'هذه النسخة تعمل ببيانات محلية تجريبية فقط إلى حين تجهيز قاعدة بيانات نسك والربط الآمن مع السيرفر.';
}
