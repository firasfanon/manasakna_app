# Session Handoff — Manasikuna v292

## Baseline الحالي
`manasikuna_v292_nusuk_bridge_preview_batch_01.zip`

## آخر حالة مؤكدة
- v291 كان مستقرًا محليًا بعد `All tests passed`.
- v292 أضاف Nusuk Bridge Preview Batch 01 دون تفعيل تسجيل دخول أو اتصال حقيقي.

## المنجز في v292
- صفحة `معاينة جسر نسك`.
- Registry لعقود preview.
- نماذج preview للحقول، الخصوصية، حالة العقد، وبوابات الربط.
- ربط الصفحة بالراوتر، الخدمات، جاهزية بيتا، وتقرير نسك للتكامل.
- تحديث الدليل الشامل.

## لا يزال ممنوعًا الآن
- تفعيل تسجيل الدخول.
- استخدام بيانات حقيقية.
- تفعيل Supabase/Remote Repository.
- كتابة شكاوى أو استبيانات إلى السيرفر.

## نقطة الاستئناف
بعد نجاح `flutter test` محليًا على v292، تكون الخطوة التالية المقترحة:
`Nusuk Bridge Preview Batch 02` لإضافة DTO وتحويلات mock وفصل Local/Remote contracts دون اتصال فعلي.


## v2.9.3+35 — Assistant Voice Material Hotfix

- أُغلق خطأ اختبار Flutter الخاص بوجود `SwitchListTile` داخل خلفية مزخرفة دون `Material` مستقل.
- تم لف خيار الإرسال التلقائي في صفحة المساعد الصوتي بـ `Material(color: Colors.transparent)`.
- لا يوجد تسجيل دخول، ولا ربط حقيقي مع نسك، ولا بيانات حقيقية، ولا اعتماد إنتاج.
