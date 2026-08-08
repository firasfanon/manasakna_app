# manasikuna v1.4 — Mobile UI Conversion Report

## الهدف
تحويل واجهة التطبيق من مظهر قريب من الويب إلى تجربة Flutter Mobile فعلية، مع بقاء التطبيق مستقلاً وخدماته مخصصة لمسار Hajj and Umrah rituals.

## ما تم تنفيذه

### 1) إلغاء التخطيط الويب من الشاشة الرئيسية
- إزالة `ConstrainedBox(maxWidth: 1080)` ومنطق `isWide` من صفحة الرئيسية.
- اعتماد `CustomScrollView` و `SliverGrid` بتخطيط هاتف مباشر.
- اعتماد Padding ثابت مناسب للهاتف بدلاً من حسابات العرض الكبيرة.

### 2) Bottom Navigation حقيقي للتطبيق
- إضافة `MunasaknaBottomNav` في:
  - `lib/core/widgets/munasakna_bottom_nav.dart`
- المسارات الأساسية:
  - الرئيسية
  - رحلتي
  - المناسك
  - الطوارئ
  - الإعدادات

### 3) Scaffold موبايل موحد
- تحديث `MunasaknaAppScaffold` ليصبح Mobile-first:
  - AppBar موبايل مدمج.
  - ListView عام قابل للتمرير.
  - إزالة توسيط المحتوى بعرض 900.
  - دعم Bottom Navigation في الصفحات الداخلية.

### 4) إعادة تصميم الصفحة الرئيسية
- Header موبايل مدمج.
- بطاقة جاهزية الرحلة.
- Quick Actions أفقية مناسبة للمس.
- شبكة خدمات 2 أعمدة مناسبة للهاتف.
- إبراز أن التطبيق Mobile + Local-only + without login.

### 5) تطوير لوحة الإعدادات كتجربة موبايل
- استبدال dropdowns الواسعة بتجربة أقرب للموبايل:
  - Choice Chips للمظهر.
  - Choice Chips للغة.
  - Choice Chips لمسار الحج/العمرة.
  - Switch tiles للخدمات.
  - Bottom sheet لتأكيد إعادة الضبط.

### 6) ضبط مؤشرات Bottom Navigation
- `JourneyPage` أصبح index = 1.
- `RitualsPage` أصبح index = 2.
- `EmergencyPage` أصبح index = 3.
- `SettingsPage` أصبح index = 4.

## ملفات عدلت
- `lib/core/widgets/munasakna_bottom_nav.dart` جديد.
- `lib/core/widgets/munasakna_app_scaffold.dart`
- `lib/core/widgets/service_card.dart`
- `lib/features/home/presentation/pages/munasakna_home_page.dart`
- `lib/features/settings/presentation/pages/settings_page.dart`
- `lib/features/journey/presentation/pages/journey_page.dart`
- `lib/features/rituals/presentation/pages/rituals_page.dart`
- `lib/features/emergency/presentation/pages/emergency_page.dart`

## ملاحظات فحص
لم يتم تشغيل Flutter داخل بيئة التنفيذ الحالية لعدم توفر Flutter/Dart، لذلك يجب تشغيل:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
```

## نقطة الاستئناف
بعد نجاح الفحص المحلي يمكن الانتقال إلى:
1. تحسين أي صفحة داخلية ما زالت تحتاج Mobile UX أعمق.
2. إضافة أيقونات تطبيق نهائية.
3. بناء AAB/IPA للنشر.
