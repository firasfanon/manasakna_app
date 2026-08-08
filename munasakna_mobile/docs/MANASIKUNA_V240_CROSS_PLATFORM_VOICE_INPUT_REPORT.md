# Manasikuna v2.4.0+19 — Batch 05 Cross-Platform Voice Assistant Input

## الهدف
تمكين المساعد الصوتي من استقبال سؤال الحاج بالصوت على Web وAndroid وiOS، ثم تحويله إلى نص وإرساله إلى المساعد المحلي الآمن، مع إبقاء الإجابة محصورة في Hajj Ritual Matrix v6 وFAQ v2.

## ما تم تنفيذه
- إضافة اعتماد `speech_to_text: ^7.3.0` لإدخال الكلام إلى نص.
- إضافة خدمة `SpeechInputService` داخل:
  - `lib/features/hajj_assistant/domain/services/speech_input_service.dart`
- تحديث صفحة `المساعد الصوتي الذكي` لتشمل:
  - زر ميكروفون واضح.
  - حالة استماع مباشرة.
  - عرض النص الملتقط قبل/أثناء الإرسال.
  - خيار إرسال السؤال تلقائيًا بعد الالتقاط.
  - خيار إلغاء الالتقاط.
  - استمرار خيار الكتابة اليدوية عند عدم توفر الميكروفون.
- الحفاظ على TTS السابق عبر `flutter_tts` لقراءة الإجابات والتنبيهات.
- إضافة أذونات المنصات:
  - Android: `RECORD_AUDIO`.
  - iOS: `NSMicrophoneUsageDescription` و `NSSpeechRecognitionUsageDescription`.
- تحديث اختبار صفحة المساعد للتحقق من ظهور لوحة الإدخال الصوتي.

## القيود المعتمدة
- المساعد لا يعمل كتنصت مستمر أو always-on assistant.
- الإدخال الصوتي يستخدم فقط عند ضغط المستخدم على زر الميكروفون.
- الأسئلة الطويلة جدًا أو المحادثات المستمرة ليست هدف هذه المرحلة.
- في الويب قد يطلب المتصفح إذن الميكروفون، وقد تختلف جودة التعرف حسب المتصفح والنظام.
- لا يوجد ربط Google Cloud أو خدمات خارجية مدفوعة في هذه المرحلة.

## الملفات المتأثرة
- `pubspec.yaml`
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`
- `lib/features/hajj_assistant/domain/services/speech_input_service.dart`
- `lib/features/hajj_assistant/presentation/pages/simple_hajj_assistant_page.dart`
- `test/widget_test.dart`
- `docs/SESSION_HANDOFF.md`

## أوامر التحقق المقترحة
```bash
cd munasakna_mobile
flutter clean
flutter pub get
flutter test
flutter run -d chrome
flutter run -d android
```
