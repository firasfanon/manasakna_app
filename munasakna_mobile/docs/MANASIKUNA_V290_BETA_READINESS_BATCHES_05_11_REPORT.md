# MANASIKUNA v2.9.0+32 — Beta Readiness Batches 05–11 Report

## النطاق
تنفيذ الدفعات 05 إلى 11 دفعة واحدة فوق baseline v286، مع تحديث الدليل الشامل.

## المنجز
1. Batch 05: توحيد الواجهة والصفحات الداخلية.
2. Batch 06: تقوية أمان المساعد والصوت.
3. Batch 07: توسيع FAQ وربطه بطابور الاعتماد.
4. Batch 08: تجهيز طبقة Nusuk Mock دون تسجيل دخول.
5. Batch 09: خطة التذكيرات والتنبيهات المحلية حسب المرحلة.
6. Batch 10: جاهزية Web/PWA وAndroid وiOS.
7. Batch 11: Final Beta Smoke & Handoff.

## الملفات المضافة
- `lib/features/beta_readiness/data/beta_batches_05_11_registry.dart`
- `lib/core/widgets/beta_batch_widgets.dart`
- صفحات Batch 05–11 داخل `lib/features/*/presentation/pages/`
- `scripts/beta_smoke.ps1`
- `scripts/beta_smoke.sh`

## الملفات المعدلة
- `pubspec.yaml`
- `web/manifest.json`
- `lib/app/router/munasakna_routes.dart`
- `lib/app/router/munasakna_router.dart`
- `lib/core/enums/munasakna_service_key.dart`
- `lib/features/home/domain/models/munasakna_service.dart`
- `lib/features/services/presentation/pages/services_page.dart`
- `lib/features/beta_readiness/presentation/pages/beta_readiness_page.dart`
- `docs/MANASIKUNA_COMPREHENSIVE_SYSTEM_GUIDE.md`
- `docs/SESSION_HANDOFF.md`

## خارج النطاق
- لا تسجيل دخول.
- لا اتصال Supabase/نسك فعلي.
- لا رفع وثائق.
- لا Push Notifications فعلي.
- لا اعتماد شرعي نهائي للمحتوى.

## التحقق المطلوب محليًا
```bash
flutter clean
flutter pub get
flutter test
flutter run -d chrome
```
