import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// طبقة إدخال صوتي محلية للمساعد الإرشادي.
///
/// تعتمد على قدرات النظام/المتصفح عبر speech_to_text. الاستخدام المقصود هو
/// أسئلة قصيرة وأوامر إرشادية، وليس تنصتًا مستمرًا أو تسجيلًا دائمًا.
class SpeechInputService {
  SpeechInputService() : _speech = SpeechToText();

  final SpeechToText _speech;
  bool _available = false;
  bool _initializing = false;

  bool get isAvailable => _available;
  bool get isListening => _speech.isListening;
  bool get isWebRuntime => kIsWeb;

  String get runtimeSupportLabel {
    if (kIsWeb) {
      return 'الويب: يعمل من المتصفح بعد ضغط زر الميكروفون، ويتطلب إذن الميكروفون من Chrome أو المتصفح.';
    }
    return 'الهاتف: يعمل على Android و iOS عبر إذن الميكروفون والتعرّف الصوتي المتاح في الجهاز.';
  }

  Future<bool> initialize({
    ValueChanged<String>? onStatus,
    ValueChanged<String>? onError,
  }) async {
    if (_available) return true;
    if (_initializing) return _available;

    _initializing = true;
    try {
      _available = await _speech.initialize(
        onStatus: (status) => onStatus?.call(_statusLabel(status)),
        onError: (error) => onError?.call(_errorLabel(error)),
        debugLogging: false,
      );
      if (!_available) {
        onError?.call('التعرّف الصوتي غير متاح على هذا الجهاز أو المتصفح. يمكنك كتابة السؤال يدويًا.');
      }
      return _available;
    } catch (_) {
      _available = false;
      onError?.call('تعذر تهيئة الميكروفون. تحقق من أذونات التطبيق أو المتصفح ثم حاول مرة أخرى.');
      return false;
    } finally {
      _initializing = false;
    }
  }

  Future<void> startListening({
    required void Function(String text, bool isFinal) onResult,
    ValueChanged<String>? onStatus,
    ValueChanged<String>? onError,
    String localeId = 'ar_SA',
  }) async {
    final ready = await initialize(onStatus: onStatus, onError: onError);
    if (!ready) return;

    await _speech.listen(
      localeId: localeId,
      listenFor: const Duration(seconds: 24),
      pauseFor: const Duration(seconds: 4),
      partialResults: true,
      cancelOnError: false,
      listenMode: ListenMode.confirmation,
      onResult: (SpeechRecognitionResult result) {
        onResult(result.recognizedWords.trim(), result.finalResult);
      },
    );
  }

  Future<void> stopListening() async {
    try {
      await _speech.stop();
    } catch (_) {
      // لا نعطّل الصفحة إن لم تكن المنصة بدأت الاستماع فعليًا.
    }
  }

  Future<void> cancelListening() async {
    try {
      await _speech.cancel();
    } catch (_) {
      // لا نعطّل الصفحة إن لم تكن المنصة بدأت الاستماع فعليًا.
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'listening':
        return 'يستمع الآن... تحدث بسؤال قصير عن الحج.';
      case 'notListening':
        return 'توقف الاستماع.';
      case 'done':
        return 'انتهى الالتقاط الصوتي.';
      default:
        return 'حالة الميكروفون: $status';
    }
  }

  String _errorLabel(SpeechRecognitionError error) {
    final message = error.errorMsg;
    if (message.contains('permission')) {
      return 'لم يتم منح إذن الميكروفون. فعّل الإذن من إعدادات الجهاز أو المتصفح.';
    }
    if (message.contains('network')) {
      return 'تعذر التعرف الصوتي بسبب مشكلة اتصال أو خدمة النظام. يمكنك كتابة السؤال يدويًا.';
    }
    if (message.contains('no_match')) {
      return 'لم ألتقط سؤالًا واضحًا. حاول بصوت أقرب أو استخدم الكتابة.';
    }
    return 'تعذر التقاط الصوت: $message';
  }
}
