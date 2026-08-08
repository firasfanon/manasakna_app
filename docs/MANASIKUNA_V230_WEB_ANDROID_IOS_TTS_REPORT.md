# MANASIKUNA v2.3.0 — Web + Android + iOS TTS Enablement

## الهدف
تمكين المساعد الصوتي في تطبيق مناسكنا ليعمل على:
- Web من خلال المتصفح على الحاسوب.
- Android.
- iOS.

## ما تم
- إضافة مجلد `web/` لتشغيل نسخة الويب.
- تحديث صفحة المساعد الصوتي لتوضح دعم الويب وأندرويد وآيفون.
- تحسين `TtsGuidanceService` ليكون أكثر تحملًا لاختلاف المنصات والمتصفحات.
- إبقاء الصوت عبر `flutter_tts` المجاني ومفتوح المصدر.
- إضافة سكربتات تشغيل وبناء:
  - `scripts/run_web_chrome.ps1`
  - `scripts/build_web.ps1`
  - `scripts/build_android_apk.ps1`
  - `scripts/run_web_chrome.sh`
  - `scripts/build_web.sh`
  - `scripts/build_android_apk.sh`

## ملاحظات تشغيل
- الويب: المتصفحات قد تمنع التشغيل التلقائي للصوت قبل تفاعل المستخدم، لذلك زر "استمع" هو المسار الآمن.
- Android: يمكن تشغيله وبناء APK من Windows.
- iOS: يمكن تشغيل الكود من نفس المشروع، لكن بناء iPhone الحقيقي أو App Store يحتاج macOS + Xcode.

## أوامر مقترحة
```bash
flutter devices
flutter run -d chrome
flutter build web --release
flutter build apk --release
```

لبناء iOS:
```bash
flutter build ios --release
```
على جهاز macOS فقط.
