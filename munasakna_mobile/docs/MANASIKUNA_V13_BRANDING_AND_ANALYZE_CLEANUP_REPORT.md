# manasikuna v1.3 — Branding / Service / Analyze Cleanup

## سبب الدفعة

تم تنفيذ هذه الدفعة بعد تشغيل المستخدم لـ `flutter analyze` وظهور ملاحظة واحدة فقط:

- `unnecessary_const` داخل `digital_card_page.dart`.

كما تم اعتماد اسم التطبيق الرسمي:

- App name: `manasikuna`
- Service: `Hajj and Umrah rituals`

## التعديلات المنفذة

### 1. الهوية التقنية

تم تحديث معرفات النشر إلى:

```text
ps.manasikuna.app
```

وشمل ذلك:

- `android/app/build.gradle`
- `android/app/src/main/kotlin/ps/manasikuna/app/MainActivity.kt`
- `ios/Runner.xcodeproj/project.pbxproj`
- `ios/Runner/Info.plist`
- `android/key.properties.example`
- سكربتات bootstrap/release notes

### 2. اسم التطبيق الظاهر

تم تثبيت الاسم الظاهر في Android/iOS وداخل التطبيق إلى:

```text
manasikuna
```

### 3. الخدمة الرسمية

تم تثبيت الوصف الرسمي للخدمة:

```text
Hajj and Umrah rituals
```

مع المقابل العربي داخل التطبيق:

```text
مناسك الحج والعمرة
```

### 4. تنظيف analyze

تم إزالة `const` الزائدة من:

```text
lib/features/digital_card/presentation/pages/digital_card_page.dart
```

### 5. الوثائق والخصوصية

تم تحديث:

- `docs/STORE_READINESS.md`
- `docs/PRIVACY_POLICY_AR.md`
- `docs/PRIVACY_POLICY_EN.md`
- `docs_PLATFORM_ENVIRONMENT.md`
- ملفات README و Session Handoff

## حالة النشر

التطبيق ما زال ضمن نفس التصميم المعتمد:

- لا تسجيل دخول.
- لا قاعدة بيانات خارجية.
- لا Supabase/Firebase.
- لا Ads/Analytics.
- يعمل محليًا.
- إذن الموقع اختياري عند الطلب فقط.

## المطلوب على جهاز التطوير

```bash
cd munasakna_mobile
flutter clean
flutter pub get
flutter analyze
flutter test
```

ثم Android:

```bash
flutter build appbundle --release
```

ثم iOS على macOS:

```bash
cd ios && pod install && cd ..
flutter build ipa --release
```

## ملاحظة

لم يتم تشغيل Flutter داخل بيئة التسليم الحالية لعدم توفر Flutter/Dart/Xcode فيها. التعديلات تمت على السورس مباشرة، وتم إجراء فحص ساكن لمسارات الهوية والتبعيات الظاهرة.
