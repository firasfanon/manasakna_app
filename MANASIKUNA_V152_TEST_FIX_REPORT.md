# manasikuna v1.5.2 — Widget Test Stabilization

## سبب التعديل
فشل `flutter test` في اختبار:

`manasikuna independent app renders core services`

بعد تحويل الواجهة إلى Mobile-first Visual Identity، أصبح الاختبار القديم يعتمد على عناصر قد تكون خارج الجزء المبني من `CustomScrollView/SliverGrid`، كما أن `SharedPreferences` يحتاج mock داخل بيئة الاختبار.

## ما تم تنفيذه

- إضافة `SharedPreferences.setMockInitialValues({})` داخل `setUp`.
- استبدال `pumpAndSettle()` بـ `pump(Duration(milliseconds: 300))` لتجنب حساسية الاختبار للأنيميشن/الانتقالات.
- تعديل توقعات الاختبار لتفحص عناصر Mobile UI الظاهرة أولًا.
- استخدام `scrollUntilVisible` لفحص الخدمات الموجودة داخل الـ SliverGrid بدل افتراض أنها مبنية فورًا.
- تحديث وصف الاختبار إلى: `manasikuna independent app renders mobile core services`.

## الملف المعدل

- `test/widget_test.dart`

## أوامر التحقق المقترحة

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
```
