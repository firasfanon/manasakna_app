# تقرير تسليم manasikuna المستقل v1.1

## الهدف

تثبيت تطبيق manasikuna كتطبيق مستقل بالكامل، وتطويره كتطبيق مستقل محلي أولًا، مع واجهات وخدمات وإعدادات مصقولة وقابلة للنشر المبدئي على Android/iOS بعد الفحص والبناء المحلي.

## الهوية التقنية

- Android applicationId: `ps.manasikuna.app`
- Android namespace: `ps.manasikuna.app`
- iOS bundle identifier: `ps.manasikuna.app`
- لا تسجيل دخول.
- لا قاعدة بيانات خارجية.
- لا Supabase/Firebase/Auth/Ads/Analytics.
- إذن الموقع اختياري فقط عند استخدام خدمة موقعي الحالي.

## التطوير المنجز

### 1. الاستقلالية

- إزالة أي تبعية لفظية أو تقنية خارجية من التطبيق.
- تغيير package/bundle إلى هوية مستقلة.
- تحديث الوثائق وسياسة الخصوصية وملفات Store Readiness.

### 2. الواجهة البصرية

- تطوير الصفحة الرئيسية بهوية مستقلة خضراء/ذهبية/كحلية.
- إضافة Header بصري، شرائط جاهزية، بطاقات خدمات أوسع، وحالات واضحة.
- تحسين التجاوب مع الشاشات الواسعة والصغيرة.

### 3. لوحة الإعدادات

- إضافة صفحة إعدادات كاملة.
- حفظ الإعدادات محليًا عبر SharedPreferences.
- إعدادات: الثيم، اللغة، حجم الخط، مسار الحج/العمرة، اسم المجموعة، تلميحات الموقع، تذكير الخصوصية، وإعادة الضبط.
- ربط الثيم واللغة وحجم الخط فعليًا بالتطبيق.

### 4. خدمات جديدة

- دليل المناسك: حج/عمرة خطوة بخطوة.
- قائمة الجاهزية: وثائق، حقيبة، قبل التحرك، مع مؤشر إنجاز.
- الصحة والسلامة: إرشادات ميدانية عامة.
- الطوارئ: إجراءات سريعة وروابط إلى الموقع والهواتف والشكاوى.

### 5. تحديث الخدمات القائمة

- تحديث بيانات الرحلة والملف المحلي.
- تحديث البطاقة الرقمية إلى صيغة مستقلة.
- تحديث الخصوصية لتؤكد أن التطبيق مستقل ومحلي.

## الفحص الساكن

تم التأكد من عدم وجود:

- Supabase
- Firebase
- AdMob
- Analytics

## ما لم يتم تشغيله هنا

لم يتم تشغيل `flutter analyze` أو `flutter test` أو build فعلي لأن بيئة التنفيذ لا تحتوي Flutter/Dart/Xcode.

## أوامر الفحص المطلوبة محليًا

```bash
cd munasakna_mobile
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build appbundle --release
```

وعلى macOS:

```bash
cd munasakna_mobile
cd ios && pod install && cd ..
flutter build ipa --release
```

## نقطة الاستئناف

ابدأ من:

- `lib/features/home/`
- `lib/features/settings/`
- `lib/features/rituals/`
- `lib/features/checklist/`
- `lib/features/health/`
- `lib/features/emergency/`
