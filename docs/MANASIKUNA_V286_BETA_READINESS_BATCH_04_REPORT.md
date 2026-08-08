# MANASIKUNA v2.8.6 — Beta Readiness Batch 04

## نطاق الدفعة
تم تنفيذ Batch 04 فوق baseline v285، مع الالتزام بأن التطوير يتم فوق v282+ فقط، وبدون تفعيل تسجيل الدخول أو الربط الفعلي مع قاعدة بيانات نسك.

## ما أضيف
- صفحة **قائمة إغلاق بيتا** لضبط بوابات الإغلاق قبل الاختبار الداخلي.
- صفحة **جاهزية المتاجر والويب** لتجهيز Android وiOS وWeb دون نشر فعلي.
- صفحة **طابور اعتماد المحتوى** لوسم المحتوى الشرعي والصحي والإداري قبل النشر.
- صفحة **سجل مخاطر الجودة** لتتبع مخاطر الفتوى، الخصوصية، الصوت، وتجربة المستخدم.
- ربط الصفحات الجديدة في الراوتر، قائمة الخدمات، صفحة الخدمات، وصفحة جاهزية بيتا.

## قرارات حاكمة
- لا نشر عام قبل اعتماد المحتوى الشرعي الحساس.
- لا تفعيل للموقع أو الوثائق أو QR الحقيقي قبل اعتماد الخصوصية وربط نسك.
- الصوت والمساعد يبقيان إرشاديين، مع بديل نصي دائم.
- أي دفعة لاحقة يجب أن تحدث الدليل الشامل قبل الإغلاق.

## ملفات متأثرة
- lib/app/router/munasakna_routes.dart
- lib/app/router/munasakna_router.dart
- lib/core/enums/munasakna_service_key.dart
- lib/features/home/domain/models/munasakna_service.dart
- lib/features/beta_readiness/presentation/pages/beta_readiness_page.dart
- lib/features/beta_closure/presentation/pages/beta_closure_checklist_page.dart
- lib/features/store_readiness/presentation/pages/store_readiness_page.dart
- lib/features/content_approval/presentation/pages/content_approval_queue_page.dart
- lib/features/quality_risks/presentation/pages/quality_risk_register_page.dart
- docs/MANASIKUNA_COMPREHENSIVE_SYSTEM_GUIDE.md
- docs/SESSION_HANDOFF.md
