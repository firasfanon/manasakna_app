# Manasikuna v2.8.4 — Beta Readiness Batch 02

## الهدف

متابعة جاهزية بيتا فوق baseline v282/v283 فقط، مع تثبيت تجربة المستخدم ومراجعة الصفحات الداخلية وتحويل عقود نسك إلى بوابات تنفيذ أوضح، دون تفعيل تسجيل الدخول أو أي ربط فعلي بالسيرفر.

## ما أُضيف

1. صفحة **مراجعة الصفحات** `/beta-review`:
   - تدقيق الصفحات الداخلية حسب الطبقة: شرعية، زمنية، تشغيلية، صحية، إدارية، مكانية.
   - تحديد ما يحتاج بيانات نسك.
   - تحديد ما يحتاج اعتماد اللجنة الشرعية.
   - تحديد المخاطر وخطوات الإغلاق لكل صفحة.

2. صفحة **سيناريوهات اختبار بيتا** `/beta-test-scenarios`:
   - سيناريوهات عملية حسب المستخدم والمنصة والمرحلة.
   - تشمل ضيف بلا تسجيل دخول، حاجة تسأل عن الإحرام، كبير سن ضل عن المجموعة، تجربة الصوت على الويب، والشكاوى في وضع الضيف.

3. صفحة **عقود الربط مع نسك** `/nusuk-contracts`:
   - تفصيل عقود ملف الحاج، حالة الرحلة، المشرف والهواتف، الشكاوى والاستبيان.
   - قواعد حماية قبل الربط: QR آمن، إذن الموقع، سجل تدقيق، عدم الكتابة للسيرفر قبل المصادقة.

4. تحديث صفحة **جاهزية بيتا**:
   - إضافة بوابات Batch 02 للانتقال إلى الصفحات الثلاث الجديدة.

5. تحديث الخدمة والراوتر:
   - `MunasaknaRoutes.betaReview`
   - `MunasaknaRoutes.betaTestScenarios`
   - `MunasaknaRoutes.nusukContracts`
   - تحديث `MunasaknaServiceKey`
   - إضافة الخدمات إلى `munasaknaInitialServices`.

## الملفات المضافة/المعدلة

- `lib/features/beta_readiness/domain/models/beta_page_audit.dart`
- `lib/features/beta_readiness/data/beta_page_audit_registry.dart`
- `lib/features/beta_review/presentation/pages/beta_review_page.dart`
- `lib/features/beta_test_scenarios/presentation/pages/beta_test_scenarios_page.dart`
- `lib/features/nusuk_contracts/presentation/pages/nusuk_contracts_page.dart`
- `lib/features/beta_readiness/presentation/pages/beta_readiness_page.dart`
- `lib/app/router/munasakna_routes.dart`
- `lib/app/router/munasakna_router.dart`
- `lib/core/enums/munasakna_service_key.dart`
- `lib/features/home/domain/models/munasakna_service.dart`
- `pubspec.yaml`
- `docs/MANASIKUNA_COMPREHENSIVE_SYSTEM_GUIDE.md`
- `docs/SESSION_HANDOFF.md`

## خارج النطاق

- لا تسجيل دخول.
- لا Supabase/API فعلي.
- لا إرسال شكاوى أو وثائق للسيرفر.
- لا تغيير في منطق المساعد الصوتي.
- لا اعتماد شرعي نهائي.

## معيار الإغلاق

- التطبيق يظل يعمل محليًا في وضع التطوير.
- الصفحات الجديدة ظاهرة من قائمة الخدمات ومن صفحة جاهزية بيتا.
- الدليل الشامل محدّث.
- أي خطأ اختبار يظهر لاحقًا يعالج موضعيًا فقط.
