# Manasikuna v1.9.0 — Hajj Matrix v6 + Contextual FAQ + Simple Assistant

## النطاق
تطوير تطبيق مناسكنا فوق baseline الحالي بوضع التطوير دون تسجيل دخول، مع تحويل مراجعة الحج الشاملة إلى واجهات فعلية محلية داخل التطبيق.

## ما تم تنفيذه
- اعتماد Hajj Ritual Matrix v6 داخل التطبيق كبيانات محلية متعددة الأبعاد.
- إضافة شاشة `مصفوفة الحج v6` لتصفية مراحل الحج حسب نوع الحج والطبقات السبع.
- إضافة `الدليل الإرشادي` بواجهات سهلة لكل طبقة: شرعية، زمنية، مكانية، إدارية، صحة وسلامة، تعليمية، تقنية.
- إضافة `Hajj FAQ Matrix v2` للأسئلة المتوقعة حسب الزمان والمكان ونوع الحج والجنس والحالة.
- إضافة شاشة `أسئلة الحج حسب المرحلة` مع فلاتر المرحلة، نوع الحج، والجنس.
- تحديث المساعد الذكي البسيط ليجيب محليًا من مصفوفة الأسئلة ومصفوفة الحج، مع إحالة المسائل الحساسة إلى اللجنة الشرعية.
- إضافة المسارات والخدمات الجديدة إلى الصفحة الرئيسية:
  - مصفوفة الحج v6
  - أسئلة الحج
  - المساعد الذكي
  - الدليل الطبقي
- تحديث الاختبارات لتشمل صفحات المصفوفة والأسئلة.

## الملفات الرئيسية المضافة
- `lib/features/hajj_matrix/domain/models/hajj_matrix_models.dart`
- `lib/features/hajj_matrix/data/hajj_ritual_matrix_v6.dart`
- `lib/features/hajj_matrix/presentation/pages/hajj_matrix_page.dart`
- `lib/features/hajj_matrix/presentation/pages/layered_guide_page.dart`
- `lib/features/hajj_faq/domain/models/hajj_faq_models.dart`
- `lib/features/hajj_faq/data/hajj_faq_matrix_v2.dart`
- `lib/features/hajj_faq/presentation/pages/contextual_faq_page.dart`
- `lib/features/hajj_assistant/domain/services/simple_hajj_assistant_service.dart`
- `lib/features/hajj_assistant/presentation/pages/simple_hajj_assistant_page.dart`

## الملفات المعدلة
- `lib/app/router/munasakna_routes.dart`
- `lib/app/router/munasakna_router.dart`
- `lib/core/enums/munasakna_service_key.dart`
- `lib/features/home/domain/models/munasakna_service.dart`
- `lib/features/home/presentation/pages/munasakna_home_page.dart`
- `test/widget_test.dart`
- `pubspec.yaml`

## قرارات حاكمة
- لا تسجيل دخول أثناء التطوير.
- لا ربط بقاعدة بيانات مؤقتًا.
- لا ارتباط بأي Legacy أو ASP.
- الإجابات الشرعية التفصيلية لا تُعرض كفتوى نهائية، بل تُوسم بالحاجة لاعتماد اللجنة الشرعية.
- المساعد الذكي الحالي محلي وتجريبي ولا يتصل بأي خدمة خارجية.

## التحقق
لم يتم تشغيل Flutter داخل بيئة ChatGPT لأن Flutter SDK غير متاح هنا. التحقق المحلي المطلوب:

```bash
cd munasakna_mobile
flutter clean
flutter pub get
flutter test
flutter run
```
