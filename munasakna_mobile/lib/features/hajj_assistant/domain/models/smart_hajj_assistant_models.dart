enum AssistantVoiceProfile {
  automatic,
  male,
  female,
}

enum AssistantResponseKind {
  answer,
  reminder,
  alert,
  question,
  referral,
}

enum AssistantSourceType {
  ritualMatrix,
  contextualFaq,
  safetyRules,
  nusukFutureData,
}

class SmartAssistantResponse {
  const SmartAssistantResponse({
    required this.kind,
    required this.title,
    required this.body,
    required this.sourceLabel,
    required this.suggestedActionLabel,
    this.needsSpecialistReferral = false,
    this.isSensitive = false,
    this.followUpQuestion,
  });

  final AssistantResponseKind kind;
  final String title;
  final String body;
  final String sourceLabel;
  final String suggestedActionLabel;
  final bool needsSpecialistReferral;
  final bool isSensitive;
  final String? followUpQuestion;

  String get displayText {
    final buffer = StringBuffer()
      ..writeln(title)
      ..writeln()
      ..writeln(body)
      ..writeln()
      ..writeln('المصدر: $sourceLabel')
      ..writeln('الإجراء: $suggestedActionLabel');
    if (followUpQuestion != null) {
      buffer
        ..writeln()
        ..writeln('سؤال متابعة: $followUpQuestion');
    }
    if (needsSpecialistReferral) {
      buffer
        ..writeln()
        ..writeln('توجيه: هذه حالة تحتاج جهة اختصاص؛ راجع اللجنة الشرعية أو المرشد أو الطوارئ حسب نوع المسألة.');
    }
    return buffer.toString().trim();
  }
}

class SmartAssistantReminder {
  const SmartAssistantReminder({
    required this.id,
    required this.title,
    required this.message,
    required this.phaseLabel,
    required this.kind,
    required this.actionLabel,
    this.requiresNusukData = false,
    this.requiresLocation = false,
    this.isCritical = false,
  });

  final String id;
  final String title;
  final String message;
  final String phaseLabel;
  final AssistantResponseKind kind;
  final String actionLabel;
  final bool requiresNusukData;
  final bool requiresLocation;
  final bool isCritical;
}

extension AssistantVoiceProfileX on AssistantVoiceProfile {
  String get labelAr {
    switch (this) {
      case AssistantVoiceProfile.automatic:
        return 'تلقائي';
      case AssistantVoiceProfile.male:
        return 'صوت ذكر';
      case AssistantVoiceProfile.female:
        return 'صوت أنثى';
    }
  }

  String get descriptionAr {
    switch (this) {
      case AssistantVoiceProfile.automatic:
        return 'يستخدم الصوت العربي الافتراضي المتاح على الجهاز، ولا يطلب اتصالًا بخادم.';
      case AssistantVoiceProfile.male:
        return 'يحاول اختيار صوت عربي ذكوري إن كان مثبتًا على الجهاز.';
      case AssistantVoiceProfile.female:
        return 'يحاول اختيار صوت عربي أنثوي إن كان مثبتًا على الجهاز.';
    }
  }
}
