import 'package:flutter/material.dart';

import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/manasikuna_visual_identity.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../data/smart_assistant_reminders.dart';
import '../../domain/models/smart_hajj_assistant_models.dart';
import '../../domain/services/simple_hajj_assistant_service.dart';
import '../../domain/services/speech_input_service.dart';
import '../../domain/services/tts_guidance_service.dart';

class SimpleHajjAssistantPage extends StatefulWidget {
  const SimpleHajjAssistantPage({super.key});

  @override
  State<SimpleHajjAssistantPage> createState() => _SimpleHajjAssistantPageState();
}

class _SimpleHajjAssistantPageState extends State<SimpleHajjAssistantPage> {
  final TextEditingController _controller = TextEditingController();
  final SimpleHajjAssistantService _assistant = const SimpleHajjAssistantService();
  final TtsGuidanceService _tts = TtsGuidanceService();
  final SpeechInputService _speech = SpeechInputService();

  AssistantVoiceProfile _voiceProfile = AssistantVoiceProfile.automatic;
  bool _voiceGuidanceEnabled = true;
  bool _isSpeaking = false;
  bool _isListening = false;
  bool _speechAvailable = false;
  bool _speechAutoSend = true;
  bool _speechSubmitted = false;
  String _speechStatus = 'اضغط زر الميكروفون واسأل سؤالًا قصيرًا عن الحج.';
  String _speechDraft = '';

  final List<_AssistantMessage> _messages = const [
    _AssistantMessage(
      isUser: false,
      text: 'السلام عليكم، أنا مساعد مناسكنا الإرشادي. أستمع لسؤالك أو أقرأه كنص، ثم أجيب من مصفوفة الحج v6 وFAQ v2 فقط. لا أفتي ولا أخمّن، وأوجهك للمرشد أو اللجنة الشرعية أو الطوارئ عند الحاجة.',
      kind: AssistantResponseKind.answer,
    ),
  ].toList();

  @override
  void dispose() {
    _controller.dispose();
    _tts.stop();
    _speech.cancelListening();
    super.dispose();
  }

  Future<void> _speakText(String text) async {
    if (!_voiceGuidanceEnabled || text.trim().isEmpty) return;
    setState(() => _isSpeaking = true);
    try {
      await _tts.speak(text: text, profile: _voiceProfile);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذر تشغيل الصوت على هذا الجهاز. تأكد من توفر صوت عربي في إعدادات النظام.')),
      );
    } finally {
      if (mounted) setState(() => _isSpeaking = false);
    }
  }

  Future<void> _stopSpeaking() async {
    await _tts.stop();
    if (mounted) setState(() => _isSpeaking = false);
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _finishListening(submitDraft: true);
      return;
    }
    await _startListening();
  }

  Future<void> _startListening() async {
    _speechSubmitted = false;
    setState(() {
      _speechDraft = '';
      _speechStatus = 'جاري تجهيز الميكروفون...';
    });

    final ready = await _speech.initialize(
      onStatus: _setSpeechStatus,
      onError: _setSpeechError,
    );

    if (!mounted) return;
    if (!ready) {
      setState(() {
        _speechAvailable = false;
        _isListening = false;
      });
      return;
    }

    setState(() {
      _speechAvailable = true;
      _isListening = true;
      _speechStatus = 'يستمع الآن... اسأل مثل: ما محظورات الإحرام؟';
    });

    await _speech.startListening(
      onStatus: _setSpeechStatus,
      onError: _setSpeechError,
      onResult: (text, isFinal) {
        if (!mounted) return;
        setState(() {
          _speechDraft = text;
          if (text.isNotEmpty) {
            _controller.text = text;
            _controller.selection = TextSelection.collapsed(offset: _controller.text.length);
          }
          if (isFinal) {
            _isListening = false;
            _speechStatus = 'تم التقاط السؤال.';
          }
        });
        if (isFinal && _speechAutoSend && text.trim().isNotEmpty && !_speechSubmitted) {
          _speechSubmitted = true;
          Future.microtask(() => _ask(text));
        }
      },
    );
  }

  Future<void> _finishListening({required bool submitDraft}) async {
    await _speech.stopListening();
    if (!mounted) return;
    final captured = _speechDraft.trim().isNotEmpty ? _speechDraft.trim() : _controller.text.trim();
    setState(() {
      _isListening = false;
      _speechStatus = captured.isEmpty ? 'توقف الاستماع دون التقاط سؤال واضح.' : 'تم إيقاف الاستماع.';
    });
    if (submitDraft && captured.isNotEmpty && !_speechSubmitted) {
      _speechSubmitted = true;
      _ask(captured);
    }
  }

  Future<void> _cancelListening() async {
    await _speech.cancelListening();
    if (!mounted) return;
    setState(() {
      _isListening = false;
      _speechDraft = '';
      _speechStatus = 'تم إلغاء الالتقاط الصوتي.';
    });
  }

  void _setSpeechStatus(String status) {
    if (!mounted) return;
    setState(() {
      _speechStatus = status;
      if (status.contains('توقف') || status.contains('انتهى')) {
        _isListening = false;
      }
    });
  }

  void _setSpeechError(String message) {
    if (!mounted) return;
    setState(() {
      _speechStatus = message;
      _isListening = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _ask([String? quickQuestion]) {
    final question = (quickQuestion ?? _controller.text).trim();
    if (question.isEmpty) return;
    final response = _assistant.respond(question);
    final message = _AssistantMessage(
      isUser: false,
      text: response.displayText,
      kind: response.kind,
      isSensitive: response.isSensitive || response.needsSpecialistReferral,
    );
    setState(() {
      _messages.add(_AssistantMessage(isUser: true, text: question, kind: AssistantResponseKind.question));
      _messages.add(message);
      _controller.clear();
      _speechDraft = '';
      _speechStatus = 'يمكنك طرح سؤال جديد بالصوت أو الكتابة.';
    });
    _speakText(message.text);
  }

  void _useReminder(SmartAssistantReminder reminder) {
    final responseTitle = reminder.kind == AssistantResponseKind.alert ? 'نبهني: ${reminder.title}' : 'ذكرني: ${reminder.title}';
    final message = _AssistantMessage(
      isUser: false,
      kind: reminder.kind,
      isSensitive: reminder.isCritical,
      text: '${reminder.title}\n\n${reminder.message}\n\nالمرحلة: ${reminder.phaseLabel}\nالإجراء: ${reminder.actionLabel}\n\n${reminder.requiresNusukData ? 'ملاحظة: سيتم تخصيص هذا التذكير لاحقًا من بيانات نسك.\n' : ''}${reminder.requiresLocation ? 'ملاحظة: يمكن ربطه لاحقًا بالموقع بعد موافقة المستخدم.\n' : ''}الصوت: ${_voiceGuidanceEnabled ? _voiceProfile.labelAr : 'متوقف حاليًا'}',
    );
    setState(() {
      _messages.add(_AssistantMessage(isUser: true, text: responseTitle, kind: AssistantResponseKind.question));
      _messages.add(message);
    });
    _speakText(message.text);
  }

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'المساعد الصوتي الذكي',
      bottomNavIndex: 3,
      headerIcon: Icons.record_voice_over_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _AssistantHero(),
          const SizedBox(height: 14),
          _VoiceInputPanel(
            isListening: _isListening,
            speechAvailable: _speechAvailable,
            autoSend: _speechAutoSend,
            status: _speechStatus,
            draft: _speechDraft,
            supportLabel: _speech.runtimeSupportLabel,
            onMicPressed: _toggleListening,
            onCancel: _cancelListening,
            onAutoSendChanged: (value) => setState(() => _speechAutoSend = value),
          ),
          const SizedBox(height: 14),
          _VoiceGuidancePanel(
            selectedProfile: _voiceProfile,
            voiceEnabled: _voiceGuidanceEnabled,
            runtimeSupportLabel: _tts.runtimeSupportLabel,
            onProfileChanged: (profile) => setState(() => _voiceProfile = profile),
            onVoiceEnabledChanged: (value) => setState(() => _voiceGuidanceEnabled = value),
          ),
          if (_isSpeaking) ...[
            const SizedBox(height: 14),
            _SpeakingIndicator(onStop: _stopSpeaking),
          ],
          const SizedBox(height: 14),
          const ManasikunaSectionTitle(
            title: 'تذكيرات وتنبيهات ذكية',
            subtitle: 'تجريبية محلية الآن، وتُخصص لاحقًا حسب بيانات نسك والموقع بإذن المستخدم',
            icon: Icons.notifications_active_rounded,
          ),
          const SizedBox(height: 10),
          for (final reminder in smartAssistantDevelopmentReminders) ...[
            _ReminderTile(reminder: reminder, onTap: () => _useReminder(reminder)),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 12),
          const ManasikunaSectionTitle(
            title: 'أسئلة سريعة',
            subtitle: 'المساعد يسأل ويجيب ضمن حدود المصفوفة ولا يهلوس',
            icon: Icons.question_answer_rounded,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final question in _quickQuestions)
                ActionChip(
                  label: Text(question),
                  avatar: const Icon(Icons.auto_awesome_rounded, size: 18),
                  onPressed: () => _ask(question),
                ),
            ],
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _controller,
            minLines: 1,
            maxLines: 3,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _ask(),
            decoration: InputDecoration(
              labelText: 'اكتب سؤالك هنا',
              hintText: 'مثال: نبهني عند الميقات أو ما محظورات الإحرام؟',
              prefixIcon: IconButton(
                tooltip: 'اسأل بالصوت',
                onPressed: _toggleListening,
                icon: Icon(_isListening ? Icons.stop_circle_rounded : Icons.mic_none_rounded),
              ),
              suffixIcon: IconButton(
                onPressed: _ask,
                icon: const Icon(Icons.send_rounded),
              ),
            ),
          ),
          const SizedBox(height: 14),
          for (final message in _messages) ...[
            _AssistantBubble(
              message: message,
              voiceEnabled: _voiceGuidanceEnabled,
              onSpeak: message.isUser ? null : () => _speakText(message.text),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 10),
          const _AssistantDisclaimer(),
        ],
      ),
    );
  }
}

class _AssistantHero extends StatelessWidget {
  const _AssistantHero();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: MunasaknaTheme.sacredGradient(scheme),
        border: Border.all(color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.42)),
      ),
      child: Row(
        children: [
          const ManasikunaKaabaMark(size: 58),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('مساعد مناسكنا الإرشادي', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text('يستمع، يقرأ، يذكّر، ينبه، ويسأل سؤال متابعة. يعمل على الويب وأندرويد وآيفون، ولا يجيب إلا من مصفوفة الحج وFAQ.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.88), height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VoiceInputPanel extends StatelessWidget {
  const _VoiceInputPanel({
    required this.isListening,
    required this.speechAvailable,
    required this.autoSend,
    required this.status,
    required this.draft,
    required this.supportLabel,
    required this.onMicPressed,
    required this.onCancel,
    required this.onAutoSendChanged,
  });

  final bool isListening;
  final bool speechAvailable;
  final bool autoSend;
  final String status;
  final String draft;
  final String supportLabel;
  final VoidCallback onMicPressed;
  final VoidCallback onCancel;
  final ValueChanged<bool> onAutoSendChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tone = isListening ? scheme.error : scheme.primary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: tone.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: tone.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(isListening ? Icons.graphic_eq_rounded : Icons.mic_rounded, color: tone),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('اسأل بالصوت', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(supportLabel, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.45)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                fit: FlexFit.loose,
                child: FilledButton.tonalIcon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(96, 48),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: onMicPressed,
                  icon: Icon(isListening ? Icons.stop_rounded : Icons.mic_rounded),
                  label: Text(isListening ? 'إيقاف' : 'تحدث'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: scheme.surface.withValues(alpha: 0.80),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.55)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(isListening ? Icons.hearing_rounded : Icons.info_outline_rounded, color: tone, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    draft.trim().isEmpty ? status : '$status\n\nالنص الملتقط: $draft',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: SwitchListTile.adaptive(
                    value: autoSend,
                    onChanged: onAutoSendChanged,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: const Text('إرسال السؤال تلقائيًا بعد الالتقاط'),
                    subtitle: const Text('يمكن إيقافها لمراجعة النص قبل الإرسال'),
                  ),
                ),
              ),
              if (isListening) ...[
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close_rounded),
                  label: const Text('إلغاء'),
                ),
              ],
            ],
          ),
          if (!speechAvailable && !isListening) ...[
            const SizedBox(height: 4),
            Text('إن لم يعمل الميكروفون، يبقى إدخال السؤال بالكتابة متاحًا دائمًا.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
          ],
        ],
      ),
    );
  }
}

class _VoiceGuidancePanel extends StatelessWidget {
  const _VoiceGuidancePanel({
    required this.selectedProfile,
    required this.voiceEnabled,
    required this.runtimeSupportLabel,
    required this.onProfileChanged,
    required this.onVoiceEnabledChanged,
  });

  final AssistantVoiceProfile selectedProfile;
  final bool voiceEnabled;
  final String runtimeSupportLabel;
  final ValueChanged<AssistantVoiceProfile> onProfileChanged;
  final ValueChanged<bool> onVoiceEnabledChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(color: scheme.shadow.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.volume_up_rounded, color: MunasaknaTheme.deepHaramGreen),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الصوت والإرشاد', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text('قراءة الردود والتذكيرات من صوت النظام المتاح على الجهاز أو المتصفح.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Switch(value: voiceEnabled, onChanged: onVoiceEnabledChanged),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final profile in AssistantVoiceProfile.values)
                ChoiceChip(
                  label: Text(profile.labelAr),
                  selected: selectedProfile == profile,
                  onSelected: voiceEnabled ? (_) => onProfileChanged(profile) : null,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(runtimeSupportLabel, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.primary, fontWeight: FontWeight.w800, height: 1.45)),
          const SizedBox(height: 6),
          Text(selectedProfile.descriptionAr, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.45)),
        ],
      ),
    );
  }
}

class _SpeakingIndicator extends StatelessWidget {
  const _SpeakingIndicator({required this.onStop});

  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          Icon(Icons.volume_up_rounded, color: MunasaknaTheme.deepHaramGreen),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('جاري تشغيل الصوت', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 5,
                    backgroundColor: scheme.surfaceContainerHighest,
                    color: MunasaknaTheme.kiswahGold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          TextButton.icon(
            onPressed: onStop,
            icon: const Icon(Icons.stop_circle_outlined),
            label: const Text('إيقاف'),
          ),
        ],
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.reminder, required this.onTap});

  final SmartAssistantReminder reminder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = reminder.kind == AssistantResponseKind.alert ? scheme.error : scheme.primary;
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
              child: Icon(reminder.kind == AssistantResponseKind.alert ? Icons.warning_amber_rounded : Icons.alarm_rounded, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(reminder.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text('${reminder.phaseLabel} • ${reminder.actionLabel}', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.play_arrow_rounded, color: color),
          ],
        ),
      ),
    );
  }
}

class _AssistantBubble extends StatelessWidget {
  const _AssistantBubble({
    required this.message,
    required this.voiceEnabled,
    this.onSpeak,
  });

  final _AssistantMessage message;
  final bool voiceEnabled;
  final VoidCallback? onSpeak;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tone = _toneColor(scheme);
    final background = message.isUser ? scheme.primary : tone.withValues(alpha: 0.08);
    final foreground = message.isUser ? scheme.onPrimary : scheme.onSurface;
    return Align(
      alignment: message.isUser ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 430),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadiusDirectional.only(
            topStart: const Radius.circular(20),
            topEnd: const Radius.circular(20),
            bottomStart: Radius.circular(message.isUser ? 20 : 6),
            bottomEnd: Radius.circular(message.isUser ? 6 : 20),
          ),
          border: message.isUser ? null : Border.all(color: tone.withValues(alpha: 0.28)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_kindIcon(), size: 17, color: tone),
                  const SizedBox(width: 5),
                  Text(_kindLabel(), style: Theme.of(context).textTheme.labelMedium?.copyWith(color: tone, fontWeight: FontWeight.w900)),
                ],
              ),
              const SizedBox(height: 7),
            ],
            Text(message.text, style: TextStyle(color: foreground, height: 1.55, fontWeight: message.isUser ? FontWeight.w800 : FontWeight.w600)),
            if (!message.isUser && voiceEnabled && onSpeak != null) ...[
              const SizedBox(height: 8),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton.icon(
                  onPressed: onSpeak,
                  icon: const Icon(Icons.volume_up_rounded, size: 18),
                  label: const Text('استمع'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _toneColor(ColorScheme scheme) {
    if (message.isUser) return scheme.primary;
    switch (message.kind) {
      case AssistantResponseKind.alert:
      case AssistantResponseKind.referral:
        return scheme.error;
      case AssistantResponseKind.reminder:
        return MunasaknaTheme.kiswahGold;
      case AssistantResponseKind.question:
        return scheme.tertiary;
      case AssistantResponseKind.answer:
        return scheme.primary;
    }
  }

  IconData _kindIcon() {
    switch (message.kind) {
      case AssistantResponseKind.alert:
        return Icons.warning_amber_rounded;
      case AssistantResponseKind.reminder:
        return Icons.alarm_rounded;
      case AssistantResponseKind.question:
        return Icons.help_outline_rounded;
      case AssistantResponseKind.referral:
        return Icons.support_agent_rounded;
      case AssistantResponseKind.answer:
        return Icons.verified_outlined;
    }
  }

  String _kindLabel() {
    switch (message.kind) {
      case AssistantResponseKind.alert:
        return 'تنبيه';
      case AssistantResponseKind.reminder:
        return 'تذكير';
      case AssistantResponseKind.question:
        return 'سؤال متابعة';
      case AssistantResponseKind.referral:
        return 'توجيه لجهة الاختصاص';
      case AssistantResponseKind.answer:
        return 'إجابة من المصفوفة';
    }
  }
}

class _AssistantDisclaimer extends StatelessWidget {
  const _AssistantDisclaimer();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.errorContainer.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.error.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline_rounded, color: scheme.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'المساعد إرشادي آمن: لا يصدر فتوى نهائية، ولا يجيب خارج مصفوفة الحج وFAQ. الإدخال الصوتي يحول كلامك إلى نص في صفحة المساعد فقط، والمسائل الخاصة تُحوّل للجنة الشرعية أو المرشد أو الطوارئ حسب الحالة.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssistantMessage {
  const _AssistantMessage({required this.isUser, required this.text, required this.kind, this.isSensitive = false});

  final bool isUser;
  final String text;
  final AssistantResponseKind kind;
  final bool isSensitive;
}

const List<String> _quickQuestions = [
  'نبهني عند الميقات',
  'ذكرني في يوم عرفة',
  'ما أنواع الحج؟',
  'ما نية التمتع؟',
  'ما محظورات الإحرام؟',
  'ماذا أفعل إذا تعبت في عرفة؟',
  'ماذا أفعل إذا ضللت عن مجموعتي؟',
  'ماذا لو تركت واجبًا؟',
];
