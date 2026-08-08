# MANASIKUNA v2.6.0 — Operational Companion Big Batch

## الهدف
تطوير دفعة كبيرة من الصفحات الداخلية فوق baseline v2.5.0، مع دمج جميع التحديثات داخل النسخة الكاملة لا كباتش منفصل.

## ما تم إنجازه

### 1. رفيق اليوم
- إضافة صفحة `رفيق اليوم`.
- عرض خطة يومية للحاج حسب المرحلة: قبل السفر، الميقات، عرفة، يوم النحر، أيام التشريق، الوداع والعودة.
- تصنيف كل مرحلة حسب الطبقة: شرعية / إدارية / صحية / ميدانية.
- إبراز المراحل الحرجة مثل الميقات وعرفة.

### 2. نوع الحج والنية
- إضافة صفحة `نوع الحج والنية`.
- مقارنة تمتع / قران / إفراد.
- عرض صيغة النية التعليمية لكل نوع.
- توضيح أثر النوع على رحلة الحاج: العمرة، التحلل، الإحرام الجديد، والهدي.

### 3. المواقيت الشرعية
- إضافة صفحة `المواقيت الشرعية`.
- عرض المواقيت الزمانية.
- عرض المواقيت المكانية.
- إضافة إطار قبل الميقات / عند الميقات / بعد الميقات.

### 4. الدليل المكاني
- إضافة صفحة `الدليل المكاني`.
- تغطية مكة، منى، عرفة، مزدلفة، والجمرات.
- ربط الصفحة بالموقع الحالي، الهواتف الضرورية، والطوارئ.

### 5. المكتبة دون إنترنت
- إضافة صفحة `المكتبة دون إنترنت`.
- تمهيد لمحتوى محلي آمن عند ضعف الشبكة.
- تقسيم المحتوى إلى دليل المناسك، السلامة، FAQ، والرسائل الصوتية المستقبلية.

## الملفات المضافة
- `lib/features/hajj_type/presentation/pages/hajj_type_page.dart`
- `lib/features/miqat/presentation/pages/miqat_page.dart`
- `lib/features/daily_companion/presentation/pages/daily_companion_page.dart`
- `lib/features/field_guide/presentation/pages/field_guide_page.dart`
- `lib/features/offline_library/presentation/pages/offline_library_page.dart`

## الملفات المعدلة
- `lib/app/router/munasakna_routes.dart`
- `lib/app/router/munasakna_router.dart`
- `lib/core/enums/munasakna_service_key.dart`
- `lib/features/home/domain/models/munasakna_service.dart`
- `lib/features/home/presentation/pages/munasakna_home_page.dart`
- `lib/features/services/presentation/pages/services_page.dart`
- `pubspec.yaml`

## ملاحظات تحقق
- لم يتم تشغيل Flutter داخل بيئة ChatGPT لعدم توفر Flutter SDK.
- يجب التحقق محليًا عبر:
  - `flutter clean`
  - `flutter pub get`
  - `flutter test`
  - `flutter run -d chrome`

## الإصدار
`2.6.0+23`
