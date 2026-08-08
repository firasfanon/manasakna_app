# Manasikuna v2.8.3 — Beta Readiness Batch 01

## الهدف
تثبيت تجربة المستخدم، توحيد المكونات، مراجعة الصفحات الداخلية، وتحضير طبقة الربط المستقبلية مع نسك دون تفعيل تسجيل الدخول.

## النطاق المنفذ
- إضافة صفحة جاهزية بيتا.
- إضافة مكونات Beta Readiness مشتركة.
- إضافة نماذج وعقود ربط مستقبلية مع نسك.
- ربط الصفحة في الراوتر وقائمة الخدمات.
- تحديث الدليل الشامل المعتمد.

## الملفات الجديدة
- `lib/core/widgets/beta_readiness_widgets.dart`
- `lib/features/beta_readiness/presentation/pages/beta_readiness_page.dart`
- `lib/features/nusuk_data/domain/models/nusuk_bridge_status.dart`
- `lib/features/nusuk_data/domain/services/nusuk_bridge_contract.dart`

## الملفات المعدلة
- `lib/app/router/munasakna_routes.dart`
- `lib/app/router/munasakna_router.dart`
- `lib/core/enums/munasakna_service_key.dart`
- `lib/features/home/domain/models/munasakna_service.dart`
- `pubspec.yaml`
- `docs/MANASIKUNA_COMPREHENSIVE_SYSTEM_GUIDE.md`
- `docs/SESSION_HANDOFF.md`

## خارج النطاق
- لا تسجيل دخول.
- لا Supabase API فعلي.
- لا رفع وثائق.
- لا إرسال شكاوى أو استبيانات للسيرفر.
- لا اعتماد شرعي نهائي.

## نقطة الاستئناف
بعد اختبار v2.8.3 محليًا، تكون الدفعة التالية المقترحة: Beta Readiness Batch 02 لمراجعة الوصول، تقليل التكرارات، واختبار الصفحات الداخلية بصريًا.
