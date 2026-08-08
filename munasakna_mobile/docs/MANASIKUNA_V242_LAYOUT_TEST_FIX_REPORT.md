# MANASIKUNA v2.4.2 Layout & Widget Test Fix Report

## Scope
تصحيح موضعي لأخطاء الاختبار والتخطيط بعد إضافة الإدخال الصوتي للمساعد.

## Fixed issues
1. أصل خطأ `BoxConstraints(w=Infinity...)` كان من استخدام `Size.fromHeight(50)` في `FilledButtonTheme` و `OutlinedButtonTheme`، وهو ينتج عرضًا غير محدود عند وضع الزر داخل `Row`.
2. تم ضبط حجم أزرار الثيم إلى `Size(48, 50)` لتجنّب العرض اللانهائي مع الحفاظ على ارتفاع واضح ومناسب.
3. تم تحصين زر الميكروفون داخل `_VoiceInputPanel` بإطار `Flexible` و `minimumSize` محلي آمن.
4. تم تحديث اختبارات الواجهات لتتعامل مع عناصر موجودة أسفل الصفحة داخل `ListView` عبر `scrollUntilVisible` قبل التحقق منها.

## Modified files
- `lib/app/theme/munasakna_theme.dart`
- `lib/features/hajj_assistant/presentation/pages/simple_hajj_assistant_page.dart`
- `test/widget_test.dart`
- `pubspec.yaml`

## Version
`2.4.2+21`

## Notes
لم يتم تغيير منطق المساعد أو خدمات الصوت أو محتوى مصفوفة الحج؛ التعديل محصور في منع قيود العرض غير المحدودة وتحسين استقرار الاختبارات.
