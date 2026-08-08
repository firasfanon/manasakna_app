# Manasikuna v1.8.0 - Batch 02: Hajj Journey Core

## الهدف
تطوير صفحة **رحلتي** لتصبح نواة عملية لمتابعة رحلة الحاج من التسجيل حتى العودة، مع إبقاء التطبيق في وضع التطوير المحلي دون تسجيل دخول ودون ربط بقاعدة بيانات خارجية.

## ما تم تنفيذه
- إضافة نموذج `JourneyOverview` لملخص الرحلة.
- توسيع نموذج `JourneyStep` ليشمل:
  - معرف المرحلة.
  - حالة المرحلة: مكتملة / جارية / قادمة / تحتاج مراجعة.
  - نطاق المرحلة: قبل السفر / السفر / أثناء الحج / بعد العودة.
  - تاريخ/وصف زمني تجريبي.
  - قائمة متابعة لكل مرحلة.
  - تنبيهات وملاحظات لكل مرحلة.
  - إجراء سريع اختياري.
- توسيع `DemoNusukRepository` ببيانات محلية كاملة لرحلة الحج.
- إضافة `journeyOverviewProvider` فوق Riverpod الحديث بدون legacy.
- إعادة بناء صفحة `JourneyPage` لتشمل:
  - بطاقة ملخص رحلة الحاج.
  - مؤشر جاهزية مبدئي.
  - بطاقة المرحلة الحالية.
  - بطاقات إحصائية للمنجز/ما يحتاج مراجعة/إجمالي المراحل.
  - Timeline واضح لمراحل رحلة الحاج.
  - Bottom sheet لتفاصيل كل مرحلة.
  - أزرار إجراءات سريعة مرتبطة بصفحات التطبيق الحالية.
- تحديث اختبار الواجهة لإضافة فحص صفحة رحلة الحاج.
- رفع رقم النسخة إلى `1.8.0+12`.

## المراحل التجريبية المعتمدة
1. التسجيل والطلب.
2. الجواز والوثائق.
3. الصحة والتطعيم.
4. التجمع والسفر.
5. أداء المناسك.
6. المتابعة الميدانية والطوارئ.
7. العودة والتقييم.

## الملفات المتأثرة
- `munasakna_mobile/lib/features/nusuk_data/domain/models/journey_step.dart`
- `munasakna_mobile/lib/features/nusuk_data/domain/models/journey_overview.dart`
- `munasakna_mobile/lib/features/nusuk_data/domain/repositories/nusuk_repository.dart`
- `munasakna_mobile/lib/features/nusuk_data/data/demo_nusuk_repository.dart`
- `munasakna_mobile/lib/features/nusuk_data/presentation/providers/nusuk_providers.dart`
- `munasakna_mobile/lib/features/journey/presentation/pages/journey_page.dart`
- `munasakna_mobile/lib/core/widgets/manasikuna_visual_identity.dart`
- `munasakna_mobile/test/widget_test.dart`
- `munasakna_mobile/pubspec.yaml`
- `docs/SESSION_HANDOFF.md`

## القيود الحالية
- البيانات تجريبية ومحلية.
- لا يوجد تسجيل دخول.
- لا يوجد Supabase/S3/API في هذه الدفعة.
- لا يتم إرسال أي بيانات شخصية خارج الجهاز.

## اختبار مقترح محليًا
```bash
cd munasakna_mobile
flutter clean
flutter pub get
flutter test
flutter run
```
