# Manasikuna v2.4.1 — Widget Test Scrollable Import Fix

## السبب
فشل `flutter test` لأن ملف `test/widget_test.dart` يستخدم `Scrollable` في `find.byType(Scrollable)` دون استيراد مكتبة widgets التي تعرّف هذا النوع في بيئة الاختبار الحالية.

## الإصلاح
تم تعديل `test/widget_test.dart` بإضافة:

```dart
import 'package:flutter/widgets.dart' show Scrollable;
```

## النطاق
- إصلاح موضعي للاختبار فقط.
- لم يتم تعديل بنية التطبيق أو واجهات المساعد أو منطق الصوت.
- تم رفع النسخة إلى `2.4.1+20`.

## ملاحظة حول MouseTracker
الرسالة:

```text
Assertion failed: mouse_tracker.dart:199 !_debugDuringDeviceUpdate
```

قد تظهر في Flutter Web debug عند تداخل حركة المؤشر/إعادة البناء أثناء التشغيل أو hot restart. بعد إصلاح الاختبار، إن تكررت أثناء التشغيل فقط وليس أثناء `flutter test`، يتم فحصها لاحقًا كخطأ runtime منفصل مرتبط بالإيماءات/المؤشر.
