import 'package:flutter/material.dart';

import '../../../app/router/munasakna_routes.dart';
import '../../../app/theme/munasakna_theme.dart';

class BetaBatchFeature {
  const BetaBatchFeature({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.color,
    this.status = 'جاهز للمتابعة',
  });

  final String title;
  final String description;
  final IconData icon;
  final String route;
  final Color color;
  final String status;
}

class ReadinessChecklistItem {
  const ReadinessChecklistItem({
    required this.title,
    required this.description,
    required this.status,
    required this.owner,
    this.isClosed = false,
    this.needsScholarApproval = false,
    this.needsNusuk = false,
  });

  final String title;
  final String description;
  final String status;
  final String owner;
  final bool isClosed;
  final bool needsScholarApproval;
  final bool needsNusuk;
}

class AssistantGuardrail {
  const AssistantGuardrail({
    required this.trigger,
    required this.allowedAnswer,
    required this.referral,
    required this.severity,
  });

  final String trigger;
  final String allowedAnswer;
  final String referral;
  final String severity;
}

class ExpandedFaqTopic {
  const ExpandedFaqTopic({
    required this.phase,
    required this.place,
    required this.audience,
    required this.question,
    required this.safeAnswer,
    required this.action,
    this.needsScholarApproval = false,
  });

  final String phase;
  final String place;
  final String audience;
  final String question;
  final String safeAnswer;
  final String action;
  final bool needsScholarApproval;
}

class NusukMockContract {
  const NusukMockContract({
    required this.name,
    required this.localSource,
    required this.futureEndpoint,
    required this.fields,
    required this.privacyRule,
    required this.readyState,
  });

  final String name;
  final String localSource;
  final String futureEndpoint;
  final List<String> fields;
  final String privacyRule;
  final String readyState;
}

class StageReminderPlan {
  const StageReminderPlan({
    required this.phase,
    required this.timeHint,
    required this.placeHint,
    required this.reminder,
    required this.voiceMode,
    required this.appAction,
    required this.priority,
  });

  final String phase;
  final String timeHint;
  final String placeHint;
  final String reminder;
  final String voiceMode;
  final String appAction;
  final String priority;
}

class PlatformReadinessItem {
  const PlatformReadinessItem({
    required this.platform,
    required this.done,
    required this.pending,
    required this.testCommand,
    required this.releaseNote,
  });

  final String platform;
  final List<String> done;
  final List<String> pending;
  final String testCommand;
  final String releaseNote;
}

class FinalSmokeGate {
  const FinalSmokeGate({
    required this.title,
    required this.checks,
    required this.closeRule,
    required this.blockerIf,
  });

  final String title;
  final List<String> checks;
  final String closeRule;
  final String blockerIf;
}

class BetaBatches0511Registry {
  const BetaBatches0511Registry._();

  static const features = [
    BetaBatchFeature(
      title: 'توحيد الواجهة والصفحات',
      description: 'مسح بصري لكل الصفحات الداخلية، وتثبيت نمط البطاقات، الأزرار، الرسائل، ومؤشرات الحالة.',
      icon: Icons.dashboard_customize_outlined,
      route: MunasaknaRoutes.uiConsistencySweep,
      color: MunasaknaTheme.haramGreen,
      status: 'Batch 05',
    ),
    BetaBatchFeature(
      title: 'أمان المساعد والصوت',
      description: 'تقوية قواعد لا فتوى ولا هلوسة، وإضافة حالات fallback للصوت والميكروفون والويب.',
      icon: Icons.record_voice_over_outlined,
      route: MunasaknaRoutes.assistantSafetyHardening,
      color: MunasaknaTheme.zamzamBlue,
      status: 'Batch 06',
    ),
    BetaBatchFeature(
      title: 'توسيع الأسئلة والاعتماد',
      description: 'توسيع FAQ حسب الزمان والمكان والجنس ونوع الحج، وربط الأسئلة الحساسة بطابور الاعتماد.',
      icon: Icons.quiz_outlined,
      route: MunasaknaRoutes.faqExpansionApproval,
      color: MunasaknaTheme.kiswahGold,
      status: 'Batch 07',
    ),
    BetaBatchFeature(
      title: 'طبقة نسك الوهمية',
      description: 'تجهيز Mock Bridge لعقود نسك دون تسجيل دخول ودون اتصال فعلي بالسيرفر.',
      icon: Icons.cloud_sync_outlined,
      route: MunasaknaRoutes.nusukBridgeMock,
      color: MunasaknaTheme.deepHaramGreen,
      status: 'Batch 08',
    ),
    BetaBatchFeature(
      title: 'التذكيرات والتنبيهات المرحلية',
      description: 'خطة تنبيهات محلية حسب المرحلة والميقات والمكان، بدون Push server الآن.',
      icon: Icons.notifications_active_outlined,
      route: MunasaknaRoutes.stageReminders,
      color: MunasaknaTheme.roseAlert,
      status: 'Batch 09',
    ),
    BetaBatchFeature(
      title: 'جاهزية Web وAndroid وiOS',
      description: 'قائمة تشغيل وبناء وفحص للأجهزة والمنصات، مع ملاحظات PWA والمتاجر.',
      icon: Icons.devices_outlined,
      route: MunasaknaRoutes.platformReadiness,
      color: MunasaknaTheme.zamzamBlue,
      status: 'Batch 10',
    ),
    BetaBatchFeature(
      title: 'دخان بيتا النهائي والتوريث',
      description: 'بوابات Smoke/Handoff النهائية قبل إعلان Beta داخلية مستقرة.',
      icon: Icons.check_circle_outline,
      route: MunasaknaRoutes.finalBetaSmoke,
      color: MunasaknaTheme.haramGreen,
      status: 'Batch 11',
    ),
  ];

  static const uiChecklist = [
    ReadinessChecklistItem(
      title: 'Scaffold موحد',
      description: 'كل صفحة جديدة تستخدم MunasaknaAppScaffold، عنوان واضح، banner وضع التطوير، وتمرير آمن.',
      status: 'مغلق للصفحات الجديدة',
      owner: 'UI',
      isClosed: true,
    ),
    ReadinessChecklistItem(
      title: 'بطاقات موحدة',
      description: 'استخدام InfoSectionCard وMunasaknaStatusChip بدل صناديق محلية غير متناسقة.',
      status: 'مغلق مبدئيًا',
      owner: 'Design System',
      isClosed: true,
    ),
    ReadinessChecklistItem(
      title: 'قراءة كبار السن',
      description: 'النصوص مختصرة، الأزرار كبيرة، ولا تعتمد الصفحة على تلميحات صغيرة فقط.',
      status: 'قيد مراجعة ميدانية',
      owner: 'UX',
    ),
    ReadinessChecklistItem(
      title: 'الصفحات الحساسة',
      description: 'أي صفحة شرعية أو صحية تعرض تحذير إحالة واضح ولا تعطي حكمًا تفصيليًا منفردًا.',
      status: 'بانتظار اعتماد المحتوى',
      owner: 'Content Governance',
      needsScholarApproval: true,
    ),
    ReadinessChecklistItem(
      title: 'صفحات نسك المستقبلية',
      description: 'الصفحات التي تحتاج بيانات حقيقية تُظهر أنها Mock/Guest ولا تعرض بيانات شخصية فعلية.',
      status: 'مجهز للربط لاحقًا',
      owner: 'Nusuk Bridge',
      needsNusuk: true,
    ),
  ];

  static const assistantGuardrails = [
    AssistantGuardrail(
      trigger: 'تركت ركنًا أو واجبًا',
      allowedAnswer: 'هذه حالة شرعية حساسة تختلف باختلاف الوقت والقدرة وما أنجزه الحاج.',
      referral: 'اللجنة الشرعية أو المرشد المعتمد فورًا',
      severity: 'حرج',
    ),
    AssistantGuardrail(
      trigger: 'محظور إحرام أو عذر النساء',
      allowedAnswer: 'يعرض المساعد قاعدة عامة فقط، ثم يحيل للتفصيل حسب الحالة.',
      referral: 'اللجنة الشرعية/المرشدة',
      severity: 'مرتفع',
    ),
    AssistantGuardrail(
      trigger: 'تعب شديد أو ضياع أو ازدحام',
      allowedAnswer: 'ابحث عن مكان آمن، لا تتحرك عشوائيًا، واتصل بالمشرف أو الطوارئ.',
      referral: 'المشرف/الطوارئ/موقعي الحالي',
      severity: 'حرج ميداني',
    ),
    AssistantGuardrail(
      trigger: 'سؤال خارج مصفوفة الحج',
      allowedAnswer: 'لا أملك إجابة معتمدة في هذا الموضوع داخل مناسكنا الآن.',
      referral: 'مصدر رسمي أو جهة الاختصاص',
      severity: 'منع هلوسة',
    ),
  ];

  static const expandedFaqTopics = [
    ExpandedFaqTopic(
      phase: 'قبل السفر',
      place: 'الوطن/المديرية',
      audience: 'الجميع',
      question: 'كيف أعرف أنني جاهز للسفر؟',
      safeAnswer: 'تأكد من الوثائق، الجواز، التطعيمات، الأدوية، بيانات المشرف، ونوع الحج. التطبيق يعرض قائمة جاهزية محلية إلى حين ربط نسك.',
      action: 'فتح قائمة الجاهزية أو محفظة الوثائق',
    ),
    ExpandedFaqTopic(
      phase: 'الميقات',
      place: 'الطائرة/الحافلة/الميقات',
      audience: 'الجميع',
      question: 'متى أبدأ التلبية؟',
      safeAnswer: 'بعد نية الدخول في النسك عند الميقات أو محاذاته، مع مراعاة برنامج الرحلة والمرشد.',
      action: 'فتح شاشة الإحرام والمواقيت',
      needsScholarApproval: true,
    ),
    ExpandedFaqTopic(
      phase: 'مكة',
      place: 'الحرم/المسعى',
      audience: 'النساء',
      question: 'ماذا أفعل إذا حدث عذر قبل الطواف؟',
      safeAnswer: 'هذه حالة حساسة ترتبط بالوقت والبرنامج، فلا تتخذي قرارًا منفردًا؛ راجعي المرشدة أو اللجنة الشرعية.',
      action: 'اسأل اللجنة الشرعية',
      needsScholarApproval: true,
    ),
    ExpandedFaqTopic(
      phase: 'عرفة',
      place: 'عرفة',
      audience: 'كبار السن/المرضى',
      question: 'ماذا أفعل إذا تعبت في عرفة؟',
      safeAnswer: 'اجلس في مكان آمن، اشرب الماء، أخبر مرافقك أو المشرف، ولا تنفرد عن المجموعة.',
      action: 'اتصال بالمشرف أو فتح الطوارئ',
    ),
    ExpandedFaqTopic(
      phase: 'الجمرات',
      place: 'منى/الجمرات',
      audience: 'الجميع',
      question: 'هل أستطيع توكيل غيري في الرمي؟',
      safeAnswer: 'التوكيل له ضوابط ترتبط بالعجز والحالة. يعرض التطبيق تنبيهًا عامًا ويحيل للمرشد أو اللجنة الشرعية.',
      action: 'اسأل اللجنة الشرعية',
      needsScholarApproval: true,
    ),
  ];

  static const nusukMockContracts = [
    NusukMockContract(
      name: 'ملف الحاج',
      localSource: 'DemoNusukRepository / بيانات ضيف',
      futureEndpoint: '/nusuk/pilgrim/profile',
      fields: ['pilgrimId', 'fullName', 'nationalIdMasked', 'companyName', 'groupName', 'hajjType', 'healthNotes'],
      privacyRule: 'إخفاء الهوية الكاملة وQR لا يحمل بيانات حساسة.',
      readyState: 'Mock جاهز، Remote مؤجل',
    ),
    NusukMockContract(
      name: 'حالة الرحلة',
      localSource: 'JourneyOverview المحلي',
      futureEndpoint: '/nusuk/pilgrim/journey',
      fields: ['currentStage', 'nextAction', 'readinessPercent', 'missingRequirements', 'stageWarnings'],
      privacyRule: 'يعرض للحاج حالته فقط بعد المصادقة مستقبلًا.',
      readyState: 'Contract جاهز',
    ),
    NusukMockContract(
      name: 'الشكاوى والاستبيان',
      localSource: 'نماذج محلية غير مرسلة',
      futureEndpoint: '/nusuk/support/tickets و /nusuk/surveys',
      fields: ['phase', 'category', 'priority', 'description', 'attachments', 'followUpStatus'],
      privacyRule: 'لا رفع مرفقات قبل Storage/RLS وسياسة خصوصية.',
      readyState: 'بحاجة RLS لاحقًا',
    ),
    NusukMockContract(
      name: 'الإشعارات والتفويج',
      localSource: 'StageReminderPlan المحلي',
      futureEndpoint: '/nusuk/pilgrim/notifications',
      fields: ['stage', 'timeWindow', 'placeContext', 'message', 'voiceEnabled', 'audience'],
      privacyRule: 'تنبيهات عامة الآن؛ التنبيهات الشخصية بعد الربط والموافقة.',
      readyState: 'Local أولًا',
    ),
  ];

  static const stageReminderPlans = [
    StageReminderPlan(
      phase: 'قبل السفر',
      timeHint: 'قبل الرحلة بأيام',
      placeHint: 'الوطن/المديرية',
      reminder: 'راجع الجواز، التطعيمات، الأدوية، المشرف، ونوع الحج.',
      voiceMode: 'تذكير صوتي اختياري',
      appAction: 'قائمة الجاهزية',
      priority: 'مهم',
    ),
    StageReminderPlan(
      phase: 'قبل الميقات',
      timeHint: 'قبل الوصول/المحاذاة',
      placeHint: 'طائرة/حافلة/ميقات',
      reminder: 'استعد للإحرام، راجع نيتك ومحظورات الإحرام.',
      voiceMode: 'تنبيه قصير',
      appAction: 'المواقيت ونوع الحج',
      priority: 'حرج شرعي',
    ),
    StageReminderPlan(
      phase: 'يوم عرفة',
      timeHint: '9 ذو الحجة',
      placeHint: 'عرفة',
      reminder: 'هذا ركن الحج الأعظم؛ الزم مجموعتك وأكثر من الدعاء والذكر.',
      voiceMode: 'تذكير إيماني',
      appAction: 'دليل عرفة',
      priority: 'حرج',
    ),
    StageReminderPlan(
      phase: 'الجمرات',
      timeHint: '11-13 ذو الحجة',
      placeHint: 'منى/الجمرات',
      reminder: 'التزم بالتفويج، لا تزاحم، واطلب المساعدة عند التعب.',
      voiceMode: 'تنبيه سلامة',
      appAction: 'الطوارئ وموقعي الحالي',
      priority: 'ميداني',
    ),
    StageReminderPlan(
      phase: 'طواف الوداع',
      timeHint: 'قبل مغادرة مكة',
      placeHint: 'المسجد الحرام/مكة',
      reminder: 'لا تغادر مكة قبل مراجعة طواف الوداع وفق حالتك وبرنامجك.',
      voiceMode: 'تذكير قبل السفر',
      appAction: 'دليل المناسك',
      priority: 'مهم',
    ),
  ];

  static const platformReadiness = [
    PlatformReadinessItem(
      platform: 'Web / PWA',
      done: ['مسار web مفعّل', 'TTS يعمل عبر زر استمع', 'واجهة responsive أساسية'],
      pending: ['أيقونات نهائية', 'manifest نهائي', 'اختبار install على الهاتف', 'سياسة كاش/Offline'],
      testCommand: 'flutter run -d chrome ثم flutter build web --release',
      releaseNote: 'الويب مناسب لبيتا داخلية بعد smoke وPWA polish.',
    ),
    PlatformReadinessItem(
      platform: 'Android',
      done: ['أذونات الميكروفون والموقع مبدئية', 'TTS/STT مدمج', 'اسم التطبيق مناسكنا'],
      pending: ['أيقونة نهائية', 'Splash معتمد', 'توقيع release', 'اختبار جهاز حقيقي'],
      testCommand: 'flutter run -d android ثم flutter build apk --release',
      releaseNote: 'لا نشر متجر قبل سياسة الخصوصية وتجربة جهاز حقيقي.',
    ),
    PlatformReadinessItem(
      platform: 'iOS',
      done: ['Info.plist مجهز للصوت والموقع', 'Bundle id مبدئي', 'Flutter UI موحد'],
      pending: ['اختبار macOS/Xcode', 'أيقونات iOS', 'إعداد signing', 'مراجعة أذونات App Store'],
      testCommand: 'flutter build ios --release على macOS فقط',
      releaseNote: 'جاهزية كودية أولية، والتحقق النهائي يتطلب Mac/Xcode.',
    ),
  ];

  static const finalSmokeGates = [
    FinalSmokeGate(
      title: 'اختبارات Flutter',
      checks: ['flutter clean', 'flutter pub get', 'flutter test', 'تشغيل Chrome smoke'],
      closeRule: 'كل الاختبارات تمر بلا failure.',
      blockerIf: 'أي red screen أو assertion في layout أو tests.',
    ),
    FinalSmokeGate(
      title: 'تنقل الصفحات',
      checks: ['الرئيسية', 'رحلتي', 'الخدمات', 'المساعد', 'جاهزية بيتا', 'بوابات 05-11'],
      closeRule: 'كل المسارات تفتح وتعود بلا crash.',
      blockerIf: 'مسار غير مسجل أو زر مكسور.',
    ),
    FinalSmokeGate(
      title: 'المحتوى الحساس',
      checks: ['أسئلة النساء', 'ترك ركن/واجب', 'محظورات الإحرام', 'التوكيل في الرمي'],
      closeRule: 'كلها تحيل للجهة المختصة ولا تفتي تفصيليًا.',
      blockerIf: 'أي إجابة حاسمة غير معتمدة.',
    ),
    FinalSmokeGate(
      title: 'نسك والخصوصية',
      checks: ['لا تسجيل دخول', 'لا بيانات حقيقية', 'لا رفع وثائق', 'QR غير حساس'],
      closeRule: 'وضع الضيف واضح بكل الصفحات ذات البيانات.',
      blockerIf: 'تخزين أو إرسال بيانات شخصية قبل الربط.',
    ),
  ];
}
