# MANASIKUNA v2.0.0+14 — Reference Visual UI Implementation

## الهدف
تطبيق الواجهة البصرية المعتمدة من الصورة المرجعية على مشروع مناسكنا، مع الحفاظ على وضع التطوير بلا تسجيل دخول وعدم ربط التطبيق بقاعدة بيانات أو أي أنظمة legacy.

## المنجز
- إعادة بناء الصفحة الرئيسية بصريًا وفق المرجع:
  - عنوان مناسكنا أعلى الصفحة.
  - Hero بصري للكعبة مع عبارة: لبيك اللهم لبيك.
  - بطاقة رحلتي الخضراء.
  - شبكة خدمات سريعة 3x3.
  - بطاقة آية الحج.
- إعادة بناء صفحة رحلتي وفق المرجع:
  - رأس أخضر كبير.
  - بطاقة حالة الرحلة بنسبة 65%.
  - بطاقة المرحلة الحالية والخطوة التالية.
  - Timeline لمراحل رحلة الحاج.
  - تنبيه مهم أسفل الصفحة.
- إضافة صفحة خدمات جديدة `/services` وفق المرجع:
  - عنوان الخدمات.
  - مربع بحث بصري.
  - بطاقات خدمات طولية بأيقونات خضراء/ذهبية.
  - بطاقة ختامية بصورة الكعبة.
- تحديث شريط التنقل السفلي ليطابق المرجع:
  - المناسك، رحلتي، الرئيسية، الرسائل، المزيد.
- إضافة أصول بصرية محلية مشتقة من الصورة المرجعية المعتمدة:
  - `kaaba_home_hero.png`
  - `home_quran_card.png`
  - `services_footer_kaaba.png`
- تحديث اختبارات الواجهة لتتبع الواجهة الجديدة.
- رفع نسخة التطبيق إلى `2.0.0+14`.

## الملفات المتأثرة
- `munasakna_mobile/lib/features/home/presentation/pages/munasakna_home_page.dart`
- `munasakna_mobile/lib/features/journey/presentation/pages/journey_page.dart`
- `munasakna_mobile/lib/features/services/presentation/pages/services_page.dart`
- `munasakna_mobile/lib/core/widgets/munasakna_bottom_nav.dart`
- `munasakna_mobile/lib/core/widgets/munasakna_app_scaffold.dart`
- `munasakna_mobile/lib/app/router/munasakna_routes.dart`
- `munasakna_mobile/lib/app/router/munasakna_router.dart`
- `munasakna_mobile/assets/images/*`
- `munasakna_mobile/test/widget_test.dart`
- `munasakna_mobile/pubspec.yaml`

## خارج النطاق
- لا يوجد ربط تسجيل دخول.
- لا يوجد ربط قاعدة بيانات.
- لا يوجد أي ارتباط legacy/ASP.
- لا يوجد اعتماد نهائي للمحتوى الشرعي قبل مراجعة اللجنة الشرعية.

## التحقق
لم يتم تشغيل Flutter داخل بيئة التنفيذ الحالية لعدم توفر SDK، ويجب تشغيل:

```bash
cd munasakna_mobile
flutter clean
flutter pub get
flutter test
flutter run
```
