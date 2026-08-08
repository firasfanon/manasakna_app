import '../../../hajj_faq/data/hajj_faq_matrix_v2.dart';
import '../../../hajj_faq/domain/models/hajj_faq_models.dart';
import '../models/smart_hajj_assistant_models.dart';

class SimpleHajjAssistantService {
  const SimpleHajjAssistantService();

  /// يحافظ على التوافق مع الصفحة القديمة والاختبارات: يرجع نصًا فقط.
  String answer(String rawQuestion) => respond(rawQuestion).displayText;

  /// إجابة منظمة: جواب، تذكير، تنبيه، سؤال متابعة، أو توجيه لجهة الاختصاص.
  /// القاعدة: لا فتوى نهائية ولا تخمين خارج المصفوفة وFAQ.
  SmartAssistantResponse respond(String rawQuestion) {
    final question = _normalize(rawQuestion);
    if (question.trim().isEmpty) {
      return const SmartAssistantResponse(
        kind: AssistantResponseKind.question,
        title: 'كيف أساعدك؟',
        body: 'اكتب سؤالك أو اختر أحد الأسئلة السريعة. أجيب من مصفوفة الحج v6 ومصفوفة الأسئلة السياقية v2 فقط، وأوجهك لجهة الاختصاص عند المسائل الحساسة.',
        sourceLabel: 'مصفوفة الحج v6 + FAQ v2',
        suggestedActionLabel: 'اختر سؤالًا سريعًا',
        followUpQuestion: 'هل سؤالك عن الإحرام، عرفة، الجمرات، الصحة، أم الشكاوى؟',
      );
    }

    final sensitive = _sensitiveReferral(question);
    if (sensitive != null) return sensitive;

    final faqAnswer = _answerFromFaq(question);
    if (faqAnswer != null) return faqAnswer;

    if (_containsAny(question, ['ذكرني', 'ذكرني', 'تذكير', 'نبهني', 'نبه', 'تنبيه'])) {
      return const SmartAssistantResponse(
        kind: AssistantResponseKind.reminder,
        title: 'تذكير ذكي تجريبي',
        body: 'أستطيع تذكيرك داخل التطبيق حسب المرحلة: قبل الميقات، عرفة، مزدلفة، الجمرات، وطواف الوداع. في وضع التطوير أعرض التذكيرات محليًا، وبعد الربط ستُبنى على بيانات نسك والموقع بموافقتك.',
        sourceLabel: 'سياسة المساعد المحلي + مصفوفة الحج v6',
        suggestedActionLabel: 'راجع بطاقات التذكير في أعلى صفحة المساعد',
        followUpQuestion: 'هل تريد تذكيرًا عن الإحرام، عرفة، الجمرات، أم طواف الوداع؟',
      );
    }

    if (_containsAny(question, ['تمتع', 'قران', 'افراد', 'إفراد', 'نوع الحج', 'انواع الحج', 'أنواع الحج'])) {
      return const SmartAssistantResponse(
        kind: AssistantResponseKind.answer,
        title: 'أنواع الحج',
        body: 'أنواع الحج ثلاثة: التمتع، والقران، والإفراد. في التمتع يعتمر الحاج أولًا ثم يتحلل ثم يحرم بالحج، وفي القران يجمع الحج والعمرة بإحرام واحد، وفي الإفراد يحرم بالحج فقط. داخل التطبيق يغيّر اختيار النوع مراحل رحلتي تلقائيًا.',
        sourceLabel: 'Hajj Ritual Matrix v6 / نوع الحج والنية',
        suggestedActionLabel: 'فتح شاشة اختيار نوع الحج لاحقًا',
        followUpQuestion: 'هل تريد معرفة نية كل نوع أو الفرق في الهدي والتحلل؟',
      );
    }

    if (_containsAny(question, ['نية', 'النية', 'لبيك'])) {
      return const SmartAssistantResponse(
        kind: AssistantResponseKind.answer,
        title: 'النية التعليمية',
        body: 'النية محلها القلب، والصيغ داخل التطبيق تعليمية: التمتع يبدأ بـ: لبيك اللهم عمرة، ثم لاحقًا: لبيك اللهم حجًا. القران: لبيك اللهم عمرة وحجًا. الإفراد: لبيك اللهم حجًا.',
        sourceLabel: 'Hajj Ritual Matrix v6 / الإحرام والنية',
        suggestedActionLabel: 'فتح دليل الإحرام والنية',
        followUpQuestion: 'ما نوع حجك: تمتع، قران، أم إفراد؟',
      );
    }

    if (_containsAny(question, ['محظور', 'محظورات', 'الاحرام', 'الإحرام', 'طيب', 'شعر', 'اظافر', 'أظافر'])) {
      return const SmartAssistantResponse(
        kind: AssistantResponseKind.answer,
        title: 'محظورات الإحرام باختصار',
        body: 'بعد الإحرام ينتبه الحاج إلى محظورات مثل إزالة الشعر عمدًا، تقليم الأظافر، استعمال الطيب، والجدال والفسوق. وللرجال محظورات خاصة مثل لبس المخيط المعتاد وتغطية الرأس مباشرة، وللنساء النقاب والقفازان. عند الخطأ أو حالة خاصة لا أحكم لك؛ بل أوجهك للجنة الشرعية.',
        sourceLabel: 'Hajj Ritual Matrix v6 / محظورات الإحرام',
        suggestedActionLabel: 'فتح شاشة محظورات الإحرام',
        needsSpecialistReferral: true,
        followUpQuestion: 'هل السؤال عن محظور عام أم خاص بالرجال أو النساء؟',
      );
    }

    if (_containsAny(question, ['ميقات', 'المواقيت', 'ذو الحليفة', 'رابغ', 'يلملم', 'ذات عرق'])) {
      return const SmartAssistantResponse(
        kind: AssistantResponseKind.alert,
        title: 'تنبيه الميقات',
        body: 'المواقيت نوعان: زمانية ومكانية. المكانية منها ذو الحليفة، الجحفة/رابغ، قرن المنازل، يلملم، وذات عرق. عند الميقات أو محاذاته ينوي الحاج النسك ويبدأ التلبية، ولا يتجاوز الميقات وهو مريد للنسك إلا محرمًا.',
        sourceLabel: 'Hajj Ritual Matrix v6 / المواقيت الشرعية',
        suggestedActionLabel: 'فتح دليل المواقيت والإحرام',
        followUpQuestion: 'هل أنت قادم من المدينة، الشام، نجد، اليمن، العراق، أم داخل المواقيت؟',
      );
    }

    if (_containsAny(question, ['عرفة', 'عرفه', 'يوم عرفة'])) {
      return const SmartAssistantResponse(
        kind: AssistantResponseKind.alert,
        title: 'عرفة: ركن الحج الأعظم',
        body: 'الوقوف بعرفة هو ركن الحج الأعظم، ويكون يوم 9 ذي الحجة. التطبيق يعرضه كمرحلة حرجة مع تنبيهات للدعاء والذكر والبقاء مع المجموعة وشرب الماء وتجنب الشمس.',
        sourceLabel: 'Hajj Ritual Matrix v6 / يوم عرفة',
        suggestedActionLabel: 'فتح دليل عرفة وتنبيهات السلامة',
        followUpQuestion: 'هل سؤالك شرعي، صحي، أم ميداني عن عرفة؟',
      );
    }

    if (_containsAny(question, ['مزدلفة', 'مزدلفه'])) {
      return const SmartAssistantResponse(
        kind: AssistantResponseKind.reminder,
        title: 'مزدلفة: راحة واستعداد',
        body: 'بعد غروب يوم عرفة تكون النفرة إلى مزدلفة. عمليًا يلتزم الحاج بتفويج الحملة، ويصلي ويذكر الله ويرتاح قدر الإمكان، ويجهز الحصى إن تيسر.',
        sourceLabel: 'Hajj Ritual Matrix v6 / مزدلفة',
        suggestedActionLabel: 'فتح دليل مزدلفة',
      );
    }

    if (_containsAny(question, ['جمرات', 'الجمرات', 'رمي', 'جمرة', 'العقبة'])) {
      return const SmartAssistantResponse(
        kind: AssistantResponseKind.alert,
        title: 'الجمرات: التزم بالتفويج',
        body: 'يوم النحر يرمي الحاج جمرة العقبة، وفي أيام التشريق يرمي الجمرات الثلاث بالترتيب حسب التفويج. في التطبيق تظهر هذه المرحلة كجدول رمي مع تنبيهات للزحام وعدم التحرك منفردًا.',
        sourceLabel: 'Hajj Ritual Matrix v6 / رمي الجمرات',
        suggestedActionLabel: 'فتح جدول الرمي وإرشادات الزحام',
      );
    }

    if (_containsAny(question, ['صحة', 'سلامة', 'حرارة', 'ماء', 'ادوية', 'أدوية', 'كبير', 'مريض'])) {
      return const SmartAssistantResponse(
        kind: AssistantResponseKind.alert,
        title: 'الصحة والسلامة',
        body: 'طبقة الصحة والسلامة تركز على شرب الماء، حمل الأدوية، تجنب الشمس والزحام، عدم التحرك منفردًا، واستخدام الطوارئ عند الحاجة. كبار السن والمرضى تظهر لهم تنبيهات أوضح عند ربط الملف الصحي لاحقًا.',
        sourceLabel: 'Hajj Ritual Matrix v6 / الصحة والسلامة',
        suggestedActionLabel: 'فتح الصحة أو الطوارئ',
        needsSpecialistReferral: true,
        followUpQuestion: 'هل الحالة تعب بسيط، ضياع عن المجموعة، أم طارئة؟',
      );
    }

    if (_containsAny(question, ['شكوى', 'شكاوى', 'استبيان', 'تقييم'])) {
      return const SmartAssistantResponse(
        kind: AssistantResponseKind.answer,
        title: 'الشكاوى والاستبيانات',
        body: 'الشكاوى والاستبيانات جزء إداري وخدمي مرتبط بنسك لاحقًا. يستطيع الحاج تقديم شكوى مرتبطة بمرحلة مثل السكن أو النقل أو الشركة، وبعد العودة يظهر استبيان تقييم التجربة.',
        sourceLabel: 'Hajj Ritual Matrix v6 / الطبقة الإدارية',
        suggestedActionLabel: 'فتح الشكاوى أو الاستبيان',
      );
    }

    if (_containsAny(question, ['موقع', 'خريطة', 'ضعت', 'ضللت', 'المجموعة'])) {
      return const SmartAssistantResponse(
        kind: AssistantResponseKind.alert,
        title: 'مساعدة ميدانية',
        body: 'عند الحاجة الميدانية يستخدم الحاج موقعي الحالي، هواتف ضرورية، أو الطوارئ. لاحقًا يمكن ربط الموقع بالمشرف بعد إذن المستخدم، مع الحفاظ على الخصوصية.',
        sourceLabel: 'Hajj Ritual Matrix v6 / الطبقة المكانية والميدانية',
        suggestedActionLabel: 'فتح موقعي الحالي أو هواتف ضرورية',
        needsSpecialistReferral: true,
        followUpQuestion: 'هل تحتاج موقعك الحالي أم رقم المشرف؟',
      );
    }

    if (_containsAny(question, ['ماذا افعل', 'ماذا أفعل', 'الان', 'الآن'])) {
      return const SmartAssistantResponse(
        kind: AssistantResponseKind.question,
        title: 'ماذا أفعل الآن؟',
        body: 'ابدأ من صفحة رحلتي: ستعرض المرحلة الحالية، ثم افتح دليل المناسك لمعرفة الحكم والخطوات، واستخدم الصحة والسلامة أو الطوارئ عند الحاجة. في وضع التطوير كل ذلك يعمل محليًا دون تسجيل دخول.',
        sourceLabel: 'Hajj Ritual Matrix v6 / الإجراء التطبيقي',
        suggestedActionLabel: 'فتح رحلتي أو دليل المناسك',
        followUpQuestion: 'أين أنت الآن: قبل السفر، الميقات، مكة، منى، عرفة، مزدلفة، أم الجمرات؟',
      );
    }

    return const SmartAssistantResponse(
      kind: AssistantResponseKind.referral,
      title: 'لم أجد جوابًا مباشرًا',
      body: 'لم أجد جوابًا مباشرًا في المساعد المحلي. جرّب كلمات مثل: نوع الحج، النية، الإحرام، عرفة، مزدلفة، الجمرات، الصحة، الشكاوى، أو الموقع. لا أخمّن ولا أقدّم فتوى خارج البيانات المعتمدة.',
      sourceLabel: 'حارس المساعد المحلي',
      suggestedActionLabel: 'إعادة صياغة السؤال أو الرجوع للمرشد/اللجنة الشرعية',
      needsSpecialistReferral: true,
      followUpQuestion: 'هل تريد أن أساعدك في اختيار المرحلة الأقرب لسؤالك؟',
    );
  }

  SmartAssistantResponse? _sensitiveReferral(String question) {
    if (!_containsAny(question, [
      'تركت ركن',
      'تركت واجب',
      'ارتكبت محظور',
      'تجاوزت الميقات',
      'نسيت طواف',
      'فاتني',
      'شككت',
      'حائض',
      'العذر',
      'توكيل',
      'نيابة',
      'جامعت',
      'فدية',
      'دم',
    ])) {
      return null;
    }
    return const SmartAssistantResponse(
      kind: AssistantResponseKind.referral,
      title: 'مسألة تحتاج توجيهًا خاصًا',
      body: 'هذا النوع من الأسئلة لا أجيب عنه كفتوى نهائية؛ لأن الحكم يتغير حسب الوقت، العذر، نوع النسك، وما فعله الحاج قبلها وبعدها. أوجّهك للمرشد أو اللجنة الشرعية المعتمدة.',
      sourceLabel: 'قواعد الأمان الشرعي في مساعد مناسكنا',
      suggestedActionLabel: 'اسأل اللجنة الشرعية أو المرشد',
      needsSpecialistReferral: true,
      isSensitive: true,
      followUpQuestion: 'هل تريد فتح أسئلة الحج العامة بدلًا من الفتوى الخاصة؟',
    );
  }

  SmartAssistantResponse? _answerFromFaq(String normalizedQuestion) {
    HajjFaqItem? best;
    var bestScore = 0;
    for (final item in hajjFaqMatrixV2) {
      var score = 0;
      for (final keyword in item.keywords) {
        if (normalizedQuestion.contains(_normalize(keyword))) score += 2;
      }
      for (final token in _normalize(item.question).split(' ')) {
        if (token.length > 3 && normalizedQuestion.contains(token)) score += 1;
      }
      if (score > bestScore) {
        bestScore = score;
        best = item;
      }
    }
    if (best == null || bestScore < 2) return null;
    final isReferral = best.answerStyle == HajjFaqAnswerStyle.referToScholar;
    final needsReferral = best.needsScholarApproval || isReferral;
    final body = StringBuffer(best.answer);
    body
      ..writeln()
      ..writeln()
      ..write('السياق: ${best.timeWindow} — ${best.placeContext}.');
    if (best.needsScholarApproval) {
      body
        ..writeln()
        ..write(' الصياغة الشرعية النهائية تحتاج اعتماد اللجنة الشرعية قبل النشر الرسمي.');
    }
    if (isReferral) {
      body
        ..writeln()
        ..write(' هذه مسألة حساسة؛ التطبيق يوجهك إلى المرشد أو اللجنة الشرعية حسب حالتك.');
    }

    return SmartAssistantResponse(
      kind: isReferral ? AssistantResponseKind.referral : AssistantResponseKind.answer,
      title: best.question,
      body: body.toString(),
      sourceLabel: 'FAQ v2 / ${best.timeWindow} / ${best.placeContext}',
      suggestedActionLabel: best.appActionLabel,
      needsSpecialistReferral: needsReferral,
      isSensitive: best.priority == HajjFaqPriority.critical,
    );
  }

  String _normalize(String value) {
    return value
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .toLowerCase();
  }

  bool _containsAny(String question, List<String> terms) {
    final normalizedTerms = terms.map(_normalize);
    return normalizedTerms.any(question.contains);
  }
}
