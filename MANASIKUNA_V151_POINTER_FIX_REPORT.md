# manasikuna v1.5.1 — Pointer Crash + Analyze Cleanup

## سبب الدفعة
ظهر عند التشغيل خطأ:

```text
Exception caught by gestures library
TypeErrorImpl: Unexpected null value
```

كما ظهر في `flutter analyze` تحذيران فقط داخل:

```text
lib/core/widgets/manasikuna_visual_identity.dart
```

## التعديلات المنفذة

### 1. استبدال Bottom Navigation
تم استبدال `NavigationBar` الجاهز بـ bottom navigation مخصص وخفيف مبني من:

- `SafeArea`
- `Row`
- `Expanded`
- `InkWell`
- `AnimatedContainer`
- `Semantics`

الهدف هو تقليل أي تداخل محتمل في pointer/gesture على Flutter Web/desktop أثناء التجربة، مع إبقاء تجربة الهاتف كما هي.

الملف:

```text
lib/core/widgets/munasakna_bottom_nav.dart
```

### 2. منع العناصر الزخرفية من استقبال hit-test
تم لف الدوائر الزخرفية في الخلفية بـ `IgnorePointer` حتى لا تشارك في مسار اللمس أو المؤشر.

الملف:

```text
lib/core/widgets/manasikuna_visual_identity.dart
```

### 3. تنظيف تحذيرات const
تم تحويل `LinearGradient` الخاص بعلامة الكعبة إلى `const LinearGradient` لإزالة ملاحظتي `prefer_const_constructors` و `prefer_const_literals_to_create_immutables`.

### 4. إزالة null assertion احترازي
تم تعديل `MunasaknaLocalizations.of(context)` حتى لا يستخدم `!`، ويعود إلى fallback عربي آمن إذا لم تكن الـ localizations جاهزة في لحظة بناء مبكرة.

الملف:

```text
lib/app/localization/munasakna_localizations.dart
```

### 5. رفع رقم النسخة

```text
version: 1.5.1+6
```

## المطلوب اختباره محليًا

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter run
```

إذا ظهر الخطأ مجددًا، المطلوب إرسال الـ stack trace كاملًا بعد سطر `Unexpected null value` لأن السطر الحالي لا يوضح الـ Widget المسبب.
