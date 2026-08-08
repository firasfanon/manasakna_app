# Manasikuna v2.2.0 — TTS Assistant Visibility & Open Source Voice

## الهدف
إظهار صفحة المساعد الصوتي بوضوح داخل الواجهة، وتفعيل قراءة صوتية فعلية مجانية/مفتوحة المصدر عبر `flutter_tts` بدل الاكتفاء بمفهوم واجهي.

## ما تم
- إضافة اعتماد `flutter_tts: ^4.2.5` إلى `pubspec.yaml`.
- إضافة طبقة `TtsGuidanceService` داخل:
  - `lib/features/hajj_assistant/domain/services/tts_guidance_service.dart`
- تحديث صفحة المساعد إلى:
  - `المساعد الصوتي الذكي`
  - تشغيل TTS فعلي لردود المساعد والتذكيرات.
  - زر `استمع` داخل كل رد من المساعد.
  - مؤشر `جاري تشغيل الصوت` مع زر إيقاف.
  - اختيار صوت: تلقائي / صوت ذكر / صوت أنثى حسب الأصوات العربية المتاحة في الجهاز.
- إظهار المساعد في الصفحة الرئيسية كخدمة سريعة باسم `المساعد الصوتي`.
- إظهاره في صفحة الخدمات باسم `المساعد الصوتي الذكي`.
- تعديل شريط التنقل السفلي من `الرسائل` إلى `المساعد`.

## ملاحظات تشغيل
- TTS يعتمد على محرك الصوت المثبت في Android/iOS.
- اختيار ذكر/أنثى يحاول مطابقة الصوت المتاح؛ إن لم يوجد صوت مطابق يعود إلى الصوت العربي الافتراضي.
- لا يوجد ربط خادم ولا خدمة مدفوعة.
- المساعد ما زال آمنًا: لا يفتي، لا يهلوس، ويجيب من المصفوفة/FAQ أو يوجه للجهة المختصة.

## ملفات معدلة
- `pubspec.yaml`
- `lib/core/widgets/munasakna_bottom_nav.dart`
- `lib/features/home/domain/models/munasakna_service.dart`
- `lib/features/home/presentation/pages/munasakna_home_page.dart`
- `lib/features/services/presentation/pages/services_page.dart`
- `lib/features/hajj_assistant/domain/models/smart_hajj_assistant_models.dart`
- `lib/features/hajj_assistant/domain/services/tts_guidance_service.dart`
- `lib/features/hajj_assistant/presentation/pages/simple_hajj_assistant_page.dart`

## الاختبار المطلوب محليًا
```bash
cd munasakna_mobile
flutter clean
flutter pub get
flutter test
flutter run
```

## نقطة الاستئناف
بعد نجاح الاختبار، نتابع تطوير الصفحات الداخلية: دليل المناسك، الأسئلة حسب المرحلة، ومحاكاة التنبيهات اليومية داخل الواجهة.
