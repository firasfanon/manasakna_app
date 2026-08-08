# Manasikuna v2.5.0 — Internal Pages Big Batch

## الهدف
تطوير الصفحات الداخلية الأساسية في تطبيق مناسكنا فوق baseline v2.4.2، مع الحفاظ على وضع التطوير بلا تسجيل دخول وبلا ربط سيرفر مؤقتًا.

## ما تم تطويره

### 1. بياناتي
- بطاقة حاج بصرية بهوية مناسكنا.
- عرض بيانات شخصية ورحلة محلية.
- إجراءات سريعة: تحديث البيانات، البطاقة الرقمية، رحلتي.

### 2. تحديث بياناتي
- نموذج أوسع يشمل الهاتف، العنوان، الطوارئ، ملاحظة صحية/احتياج خاص.
- سبب التحديث وأولوية المراجعة.
- رقم مرجعي محلي.

### 3. قائمة الجاهزية
- تصفية حسب: الكل، قبل السفر، المشاعر، السلامة.
- عناصر موسعة للوثائق، الحقيبة، الإحرام، المشاعر، السلامة.
- مؤشر إنجاز محلي.

### 4. مواعظ وأحكام
- إرشادات حسب المرحلة: قبل السفر، الإحرام، عرفة، الزحام، بعد العودة.
- ربط سريع باللجنة الشرعية والمساعد.

### 5. اللجنة الشرعية
- تنظيم الأسئلة الحساسة حسب المحاور.
- وسم الأسئلة التي تحتاج اعتمادًا شرعيًا.
- توجيه واضح أن التطبيق لا يفتي.

### 6. الصحة والسلامة
- بطاقات موسعة للحرارة، الأمراض المزمنة، كبار السن وذوي الإعاقة، الزحام والجمرات.
- أزرار طوارئ وموقعي وأرقام.

### 7. الطوارئ
- خطة تصرف عند الضياع.
- إجراءات سريعة: تحديد موقعي، أرقام ضرورية، الصحة، الشكاوى.

### 8. الشكاوى
- إضافة المرحلة، نوع الشكوى، الأولوية.
- مسار متابعة متوقع محليًا.

### 9. الاستبيان
- تقييم محاور موسعة: الشركة، السكن، النقل، الإرشاد، الصحة، التفويج.
- اختيار مرحلة التقييم ومتوسط عام.

### 10. الهواتف الضرورية
- تصنيف أرقام المشرفين، الدعم والطوارئ، الجهات الإرشادية.
- تنبيه أن الأرقام تجريبية إلى حين الربط بنسك.

### 11. مواقيت الصلاة
- واجهة مواقيت يومية مرئية.
- توضيح أن الأوقات محلية وتجريبية حتى الربط بالموقع والمشاعر.

### 12. روابط مفيدة
- تصنيف مصادر رسمية، إرشاد الحاج، السلامة والميدان.
- بدائل داخل التطبيق للمصفوفة والأسئلة والدليل الطبقي.

### 13. موقعي الحالي
- تحسين واجهة الإذن والموقع.
- إضافة إرشادات مشاركة آمنة وخطة عند الضياع.

### 14. البطاقة الرقمية
- بطاقة QR بصرية أكثر وضوحًا.
- بيان نطاق البيانات المسموح وغير المسموح داخل QR.

### 15. صفحة جديدة: الإشعارات والتنبيهات
- مركز تنبيهات محلي مبني على مراحل الحج.
- مجموعات: قبل السفر، الإحرام والميقات، أيام الحج، السلامة والطوارئ.
- ربط سريع بالمساعد والأسئلة.

## ملفات رئيسية تم تعديلها
- lib/features/profile/presentation/pages/profile_page.dart
- lib/features/profile/presentation/pages/update_profile_page.dart
- lib/features/checklist/presentation/pages/checklist_page.dart
- lib/features/guidance/presentation/pages/guidance_page.dart
- lib/features/fatwa/presentation/pages/fatwa_page.dart
- lib/features/health/presentation/pages/health_page.dart
- lib/features/emergency/presentation/pages/emergency_page.dart
- lib/features/complaints/presentation/pages/complaints_page.dart
- lib/features/survey/presentation/pages/survey_page.dart
- lib/features/contacts/presentation/pages/contacts_page.dart
- lib/features/prayer_times/presentation/pages/prayer_times_page.dart
- lib/features/useful_links/presentation/pages/useful_links_page.dart
- lib/features/location/presentation/pages/current_location_page.dart
- lib/features/digital_card/presentation/pages/digital_card_page.dart
- lib/features/notifications/presentation/pages/notifications_page.dart
- lib/app/router/munasakna_routes.dart
- lib/app/router/munasakna_router.dart
- lib/core/enums/munasakna_service_key.dart
- lib/features/home/domain/models/munasakna_service.dart
- lib/features/services/presentation/pages/services_page.dart
- pubspec.yaml

## خارج النطاق
- لا يوجد تسجيل دخول.
- لا يوجد ربط Supabase/نسك.
- لا يوجد إرسال حقيقي للشكاوى أو الاستبيانات.
- لا يوجد Push Notifications حقيقي حتى الآن.

## التحقق
لم يتم تشغيل Flutter داخل بيئة ChatGPT لعدم توفر Flutter SDK. يجب التحقق محليًا عبر:

```bash
flutter clean
flutter pub get
flutter test
flutter run -d chrome
```

## نقطة الاستئناف التالية
Batch 07 المقترح: إغلاق صفحات الدليل التفاعلي والمصفوفة والFAQ بصريًا وربطها أكثر بصفحات الرحلة والمساعد، ثم توليد APK تجريبي عند استقرار الاختبارات.
