import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../models/smart_hajj_assistant_models.dart';

/// طبقة صوت محلية/مفتوحة المصدر للمساعد الإرشادي.
///
/// تعمل عبر flutter_tts على Android و iOS و Web، ولا تستخدم أي خدمة مدفوعة
/// أو ربط خادم. في الويب يعتمد التشغيل على Web Speech API داخل المتصفح،
/// وقد يتطلب المتصفح ضغط المستخدم على زر "استمع" قبل السماح بالصوت.
class TtsGuidanceService {
  TtsGuidanceService() : _tts = FlutterTts();

  final FlutterTts _tts;
  AssistantVoiceProfile? _configuredProfile;

  bool get isWebRuntime => kIsWeb;

  String get runtimeSupportLabel {
    if (kIsWeb) {
      return 'الويب: يعمل من المتصفح عبر صوت النظام، وقد يحتاج تشغيلًا يدويًا من المستخدم.';
    }
    return 'الهاتف: يعمل عبر محرك الصوت المحلي في Android أو iOS.';
  }

  Future<void> speak({
    required String text,
    required AssistantVoiceProfile profile,
  }) async {
    final normalized = _normalizeSpeechText(text);
    if (normalized.isEmpty) return;

    await _configure(profile);
    await stop();
    await _tts.speak(normalized);
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {
      // تجاهل أخطاء الإيقاف في الاختبارات أو المتصفحات التي لا تبدأ تشغيلًا فعليًا.
    }
  }

  Future<void> _configure(AssistantVoiceProfile profile) async {
    if (_configuredProfile == profile) return;

    await _safe(() => _tts.setLanguage('ar-SA'));
    await _safe(() => _tts.setSpeechRate(kIsWeb ? 0.50 : 0.46));
    await _safe(() => _tts.setPitch(1.0));
    await _safe(() => _tts.setVolume(1.0));
    await _safe(() => _tts.awaitSpeakCompletion(false));

    final voice = await _selectArabicVoice(profile);
    if (voice != null) {
      await _safe(() => _tts.setVoice(voice));
    }

    _configuredProfile = profile;
  }

  Future<Map<String, String>?> _selectArabicVoice(AssistantVoiceProfile profile) async {
    if (profile == AssistantVoiceProfile.automatic) return null;

    Object? voicesResult;
    try {
      voicesResult = await _tts.getVoices;
    } catch (_) {
      return null;
    }

    if (voicesResult is! List) return null;

    final voices = voicesResult
        .whereType<Map>()
        .map((voice) => voice.map((key, value) => MapEntry('$key', '$value')))
        .where((voice) => _isArabicVoice(voice))
        .toList();

    if (voices.isEmpty) return null;

    final genderMatch = voices.where((voice) => _matchesGender(voice, profile)).toList();
    final selected = genderMatch.isNotEmpty ? genderMatch.first : voices.first;
    final name = selected['name'];
    final locale = selected['locale'];
    if (name == null || locale == null) return null;
    return <String, String>{'name': name, 'locale': locale};
  }

  bool _isArabicVoice(Map<String, String> voice) {
    final locale = (voice['locale'] ?? '').toLowerCase();
    final name = (voice['name'] ?? '').toLowerCase();
    final lang = (voice['lang'] ?? '').toLowerCase();
    return locale.startsWith('ar') ||
        lang.startsWith('ar') ||
        name.contains('arabic') ||
        name.contains('arab');
  }

  bool _matchesGender(Map<String, String> voice, AssistantVoiceProfile profile) {
    final haystack = [
      voice['gender'],
      voice['name'],
      voice['identifier'],
      voice['quality'],
    ].whereType<String>().join(' ').toLowerCase();

    switch (profile) {
      case AssistantVoiceProfile.male:
        return haystack.contains('male') || haystack.contains('man') || haystack.contains('m1') || haystack.contains('male_');
      case AssistantVoiceProfile.female:
        return haystack.contains('female') || haystack.contains('woman') || haystack.contains('f1') || haystack.contains('female_');
      case AssistantVoiceProfile.automatic:
        return false;
    }
  }

  Future<void> _safe(Future<dynamic> Function() action) async {
    try {
      await action();
    } catch (_) {
      // بعض المنصات أو المتصفحات لا تدعم كل إعدادات الصوت.
      // الفشل هنا لا يجب أن يعطل المساعد، بل يعود للصوت الافتراضي.
    }
  }

  String _normalizeSpeechText(String text) {
    return text
        .replaceAll(RegExp(r'المصدر:.*', multiLine: true), '')
        .replaceAll(RegExp(r'الإجراء:.*', multiLine: true), '')
        .replaceAll(RegExp(r'توجيه:.*', multiLine: true), 'هذه حالة تحتاج جهة اختصاص.')
        .replaceAll('v6', 'الإصدار السادس')
        .replaceAll('FAQ', 'الأسئلة الشائعة')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
