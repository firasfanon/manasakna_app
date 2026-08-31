# MANASIKUNA v292 — Nusuk Bridge Preview Batch 01

## الحالة
تم تنفيذ الدفعة فوق v291 المستقر، دون تفعيل تسجيل الدخول، ودون اتصال فعلي مع نسك أو Supabase.

## الهدف
تحويل تقرير التكامل مع نسك من وثيقة وصفية إلى معاينة عملية داخل التطبيق تعرض:

- عقود القراءة والكتابة المقترحة.
- الحقول المطلوبة لكل عقد.
- مستوى الخصوصية لكل حقل.
- Payload تجريبي مقنّع.
- قواعد القبول قبل الربط.
- سلوك الفشل الآمن عند تعذر الاتصال لاحقًا.

## الملفات الجديدة

- `lib/features/nusuk_bridge_preview/domain/models/nusuk_bridge_preview_models.dart`
- `lib/features/nusuk_bridge_preview/data/nusuk_bridge_preview_registry.dart`
- `lib/features/nusuk_bridge_preview/presentation/pages/nusuk_bridge_preview_page.dart`

## العقود المعروضة في المعاينة

1. معاينة ملف الحاج: `/api/nusuk/me/profile`
2. معاينة حالة الرحلة: `/api/nusuk/me/journey-overview`
3. معاينة المشرف والهواتف: `/api/nusuk/me/contacts`
4. معاينة الشكاوى والاستبيانات: `/api/nusuk/me/feedback`

## قواعد الأمان

- لا يتم تفعيل المصادقة في هذه الدفعة.
- لا يتم إرسال أو قراءة أي بيانات من السيرفر.
- لا يتم عرض هوية كاملة أو بيانات حساسة داخل Payload التجريبي.
- أي كتابة للشكاوى أو الاستبيانات تبقى مؤجلة حتى RLS والمصادقة وسجل التدقيق.
- عند فشل الربط لاحقًا، يبقى الدليل والمصفوفة والمساعد المحلي متاحين دون ادعاء بيانات رسمية.

## الربط داخل التطبيق

تم ربط صفحة `معاينة جسر نسك` في:

- الراوتر.
- قائمة الخدمات.
- صفحة جاهزية بيتا.
- تقرير نسك للتكامل.

## ما لم يتم تنفيذه

- لم يتم تفعيل تسجيل الدخول.
- لم يتم بناء Remote Repository حقيقي.
- لم يتم إنشاء Supabase schema أو RPC.
- لم يتم استخدام أي بيانات حقيقية.

## الخطوة التالية المقترحة

Nusuk Bridge Preview Batch 02:

- إضافة DTO classes جاهزة للـ JSON serialization يدويًا أو عبر generator لاحقًا.
- إضافة `NusukLocalPreviewDataSource` و `NusukRemoteDataSource` كعقود فقط.
- إضافة اختبارات لعقود التحويل المحلي قبل أي سيرفر.
