import '../domain/models/journey_overview.dart';
import '../domain/models/journey_step.dart';
import '../domain/models/pilgrim_profile.dart';
import '../domain/repositories/nusuk_repository.dart';

class DemoNusukRepository implements NusukRepository {
  const DemoNusukRepository();

  @override
  Future<PilgrimProfile> getMyProfile() async {
    return const PilgrimProfile(
      fullNameAr: 'حاج / معتمر',
      nationalId: 'لا يعرض في النسخة المحلية',
      applicationNo: 'MNK-LOCAL-1447-0001',
      statusLabelAr: 'جاهزية محلية',
      companyNameAr: 'حملة أو مجموعة السفر',
      groupNameAr: 'المجموعة الأساسية',
      phone: 'أضف رقمك من صفحة تحديث البيانات',
    );
  }

  @override
  Future<JourneyOverview> getJourneyOverview() async {
    return const JourneyOverview(
      titleAr: 'رحلة الحاج من التسجيل حتى العودة',
      subtitleAr: 'متابعة مبسطة لمراحل الحج في وضع التطوير المحلي دون تسجيل دخول.',
      currentStatusAr: 'المرحلة الحالية: استكمال الجاهزية والوثائق',
      nextMilestoneAr: 'الخطوة التالية: مراجعة الجواز، التطعيم، ونقطة التجمع',
      travelWindowAr: 'موعد السفر: يحدد لاحقًا من نظام نسك',
      readinessLabelAr: 'جاهزية مبدئية',
      progress: 0.42,
    );
  }

  @override
  Future<List<JourneyStep>> getJourneySteps() async {
    return const [
      JourneyStep(
        id: 'registration',
        titleAr: 'التسجيل والطلب',
        descriptionAr: 'تجهيز بيانات الطلب الأساسية ومتابعة حالة القبول لاحقًا عبر نظام نسك.',
        status: JourneyStepStatus.completed,
        stageLabelAr: 'قبل السفر',
        dateLabelAr: 'مكتمل تجريبيًا',
        checklistItemsAr: [
          'التحقق من الاسم ورقم الهوية',
          'تأكيد رقم الهاتف للتواصل',
          'مراجعة بيانات المرافق عند وجوده',
        ],
        tipsAr: [
          'احتفظ بصورة رقمية من بيانات الطلب.',
          'لا تشارك رقم الطلب إلا مع الجهات الرسمية أو المشرف المعتمد.',
        ],
        actionLabelAr: 'عرض بياناتي',
      ),
      JourneyStep(
        id: 'documents',
        titleAr: 'الجواز والوثائق',
        descriptionAr: 'مراجعة الجواز، الوثائق المطلوبة، والصور المهمة قبل موعد التسليم أو السفر.',
        status: JourneyStepStatus.attention,
        stageLabelAr: 'قبل السفر',
        dateLabelAr: 'يتطلب مراجعة',
        checklistItemsAr: [
          'التأكد من صلاحية جواز السفر',
          'حفظ صورة الجواز والهوية',
          'تجهيز أي وثيقة تطلبها الجهة المنظمة',
        ],
        tipsAr: [
          'ضع الوثائق الأصلية في مكان آمن وسهل الوصول.',
          'احتفظ بنسخة ورقية ورقمية من الوثائق المهمة.',
        ],
        actionLabelAr: 'افتح قائمة الجاهزية',
      ),
      JourneyStep(
        id: 'health',
        titleAr: 'الصحة والتطعيم',
        descriptionAr: 'متابعة المتطلبات الصحية والتطعيمات والتنبيهات الطبية قبل الحركة.',
        status: JourneyStepStatus.current,
        stageLabelAr: 'قبل السفر',
        dateLabelAr: 'قيد المتابعة',
        checklistItemsAr: [
          'مراجعة المتطلبات الصحية الرسمية',
          'تجهيز الأدوية الشخصية',
          'حفظ معلومات الحساسية أو الأمراض المزمنة إن وجدت',
        ],
        tipsAr: [
          'استشر الطبيب في الأدوية المزمنة قبل السفر.',
          'احمل وصفاتك الطبية الأساسية معك.',
        ],
        actionLabelAr: 'السلامة والصحة',
      ),
      JourneyStep(
        id: 'departure',
        titleAr: 'التجمع والسفر',
        descriptionAr: 'معرفة نقطة التجمع، وقت التحرك، ووسيلة التواصل مع المشرف.',
        status: JourneyStepStatus.upcoming,
        stageLabelAr: 'السفر',
        dateLabelAr: 'لاحقًا',
        checklistItemsAr: [
          'حفظ رقم المشرف',
          'مراجعة وقت ونقطة التجمع',
          'شحن الهاتف وتجهيز بطارية متنقلة',
        ],
        tipsAr: [
          'اذهب إلى نقطة التجمع مبكرًا.',
          'لا تتحرك منفردًا بعيدًا عن المجموعة دون إبلاغ المشرف.',
        ],
        actionLabelAr: 'هواتف ضرورية',
      ),
      JourneyStep(
        id: 'rituals',
        titleAr: 'أداء المناسك',
        descriptionAr: 'الرجوع إلى دليل المناسك والأحكام والفتاوى عند الحاجة أثناء الرحلة.',
        status: JourneyStepStatus.upcoming,
        stageLabelAr: 'أثناء الحج',
        dateLabelAr: 'لاحقًا',
        checklistItemsAr: [
          'مراجعة أعمال الإحرام والطواف والسعي',
          'معرفة أعمال عرفة ومزدلفة ومنى',
          'سؤال المرشد الشرعي عند الاشتباه',
        ],
        tipsAr: [
          'لا تعتمد على معلومات متداولة غير موثوقة.',
          'خذ بالرخص الشرعية المعتمدة عند الحاجة وبسؤال أهل العلم.',
        ],
        actionLabelAr: 'دليل المناسك',
      ),
      JourneyStep(
        id: 'field_support',
        titleAr: 'المتابعة الميدانية والطوارئ',
        descriptionAr: 'استخدام الموقع الحالي، أرقام الطوارئ، والشكاوى عند الحاجة.',
        status: JourneyStepStatus.upcoming,
        stageLabelAr: 'أثناء الحج',
        dateLabelAr: 'لاحقًا',
        checklistItemsAr: [
          'حفظ أرقام الطوارئ والمشرف',
          'تفعيل الموقع عند الحاجة فقط',
          'تقديم شكوى أو ملاحظة عند وجود مشكلة تشغيلية',
        ],
        tipsAr: [
          'شارك موقعك مع المشرف فقط عند الحاجة.',
          'استخدم الشكاوى للملاحظات التشغيلية وليس للأسئلة الشرعية.',
        ],
        actionLabelAr: 'الطوارئ',
      ),
      JourneyStep(
        id: 'return_review',
        titleAr: 'العودة والتقييم',
        descriptionAr: 'تقييم الخدمات وتوثيق الملاحظات بعد انتهاء الرحلة والعودة.',
        status: JourneyStepStatus.upcoming,
        stageLabelAr: 'بعد العودة',
        dateLabelAr: 'بعد الرحلة',
        checklistItemsAr: [
          'استكمال استبيان الحج',
          'تسجيل الملاحظات المهمة',
          'الاحتفاظ بأي وثائق أو رسائل ختامية',
        ],
        tipsAr: [
          'يساعد الاستبيان في تحسين الخدمات للحجاج القادمين.',
          'اكتب الملاحظة بشكل واضح ومحدد.',
        ],
        actionLabelAr: 'استبيان الحج',
      ),
    ];
  }

  @override
  Future<List<String>> getGuidanceItems() async => const [
        'الإحرام والنية ومواقيت الإحرام',
        'الطواف والسعي وآدابهما',
        'الوقوف بعرفة وأعمال يوم عرفة',
        'المبيت بمزدلفة ومنى',
        'رمي الجمرات والهدي والحلق أو التقصير',
        'طواف الوداع وتنبيهات السفر',
        'آداب التعامل مع الزحام وكبار السن والمرضى',
      ];

  @override
  Future<List<String>> getFatwaItems() async => const [
        'ما حكم من نسي واجبًا من واجبات الحج؟',
        'هل يجوز التوكيل في الرمي؟',
        'ما محظورات الإحرام؟',
        'متى يجوز التحلل؟',
        'ما الذي يفعله من ضل عن مجموعته؟',
        'متى يجب سؤال المرشد بدل الاعتماد على معلومات عامة؟',
      ];

  @override
  Future<List<String>> getImportantContacts() async => const [
        'الطوارئ المحلي: حسب البلد الموجود فيه الحاج',
        'مشرف المجموعة: أضفه من الإعدادات أو احتفظ به يدويًا',
        'الدعم الميداني: يحدد لاحقًا من الحملة',
        'الإرشاد الشرعي: رقم المفتي أو المرشد المعتمد',
        'المساعدة الصحية: أقرب نقطة طبية أو إسعاف',
      ];

  @override
  Future<List<String>> getUsefulLinks() async => const [
        'دليل مناسك الحج والعمرة',
        'إرشادات السلامة في السفر',
        'إرشادات صحية للحجاج والمعتمرين',
        'قائمة وثائق السفر',
        'تنبيهات التفويج والتنقل',
      ];
}
