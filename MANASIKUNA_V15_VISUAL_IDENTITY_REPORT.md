# manasikuna v1.5 — Visual Identity Upgrade

## الهدف
تحويل واجهة manasikuna من واجهة موبايل عامة إلى واجهة بصرية خاصة بتطبيق مناسك الحج والعمرة، مع الحفاظ على استقلال التطبيق وعدم إضافة قواعد بيانات أو تسجيل دخول أو خدمات خارجية.

## الهوية البصرية المعتمدة
- أخضر الحرم: `#0B5D4B`
- أخضر عميق: `#073B31`
- أسود الكسوة: `#111827`
- ذهبي الكسوة: `#D6A83B`
- عاج الإحرام: `#FBF7EA`
- أزرق زمزم: `#0E7490`

## ما تم تطويره
1. إعادة بناء Theme التطبيق بهوية الحج والعمرة.
2. إضافة خلفية بصرية ناعمة للتطبيق بدل الخلفية المسطحة.
3. إضافة علامة بصرية Kaaba Mark داخل التطبيق دون أصول خارجية.
4. تطوير Home Hero بهوية خاصة للتطبيق، مع شارات محلية/بدون تسجيل دخول/حج وعمرة.
5. تطوير بطاقات الخدمات بإحساس موبايل خاص وتدرجات ولمسات ذهبية.
6. تطوير Bottom Navigation ليظهر كعنصر موبايل عائم بدل شريط عادي.
7. تطوير صفحة المناسك إلى Timeline بصري للحج والعمرة.
8. تطوير صفحة الرحلة إلى Timeline بصري مع مؤشر تقدم.
9. تطوير InfoSectionCard لتوريث الهوية على الصفحات الأخرى.
10. الحفاظ على استقلالية التطبيق: لا Supabase، لا Firebase، لا Auth، لا Ads، لا Analytics.

## الملفات الأساسية المعدلة/المضافة
- `lib/app/theme/munasakna_theme.dart`
- `lib/core/widgets/manasikuna_visual_identity.dart`
- `lib/core/widgets/munasakna_app_scaffold.dart`
- `lib/core/widgets/munasakna_bottom_nav.dart`
- `lib/core/widgets/service_card.dart`
- `lib/core/widgets/info_section_card.dart`
- `lib/features/home/presentation/pages/munasakna_home_page.dart`
- `lib/features/rituals/presentation/pages/rituals_page.dart`
- `lib/features/journey/presentation/pages/journey_page.dart`

## ملاحظات تشغيل
لم يتم تشغيل Flutter داخل بيئة العمل الحالية لعدم توفر Flutter/Dart هنا. يجب التشغيل محليًا:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
```

ثم بناء Android:

```bash
flutter build appbundle --release
```

وعلى macOS لـ iOS:

```bash
cd ios && pod install && cd ..
flutter build ipa --release
```
