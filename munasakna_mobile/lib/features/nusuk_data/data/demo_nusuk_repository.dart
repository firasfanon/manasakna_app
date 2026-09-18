import '../domain/models/journey_overview.dart';
import '../domain/models/journey_step.dart';
import '../domain/models/pilgrim_profile.dart';
import '../domain/repositories/nusuk_repository.dart';

class DemoNusukRepository implements NusukRepository {
  const DemoNusukRepository({this.ritualPath = 'hajj'});
  final String ritualPath;
  bool get _isUmrah => ritualPath == 'umrah';

  @override
  Future<PilgrimProfile> getMyProfile() async => PilgrimProfile(
        fullNameAr: _isUmrah ? 'معتمر / معتمرة' : 'حاج / حاجة',
        nationalId: 'لا يعرض في النسخة المحلية',
        applicationNo:
            _isUmrah ? 'MNK-LOCAL-UMRAH-0001' : 'MNK-LOCAL-HAJJ-1448-0001',
        statusLabelAr: 'جاهزية محلية',
        companyNameAr:
            _isUmrah ? 'شركة أو مجموعة العمرة' : 'حملة أو مجموعة الحج',
        groupNameAr: 'المجموعة الأساسية',
        phone: 'أضف رقمك من صفحة تحديث البيانات',
      );

  @override
  Future<JourneyOverview> getJourneyOverview() async => _isUmrah
      ? const JourneyOverview(
          titleAr: 'رحلة المعتمر من الاستعداد حتى العودة',
          subtitleAr:
              'متابعة مراحل العمرة بإشراف الشركة المنظمة وتنسيق الجهات الرسمية.',
          currentStatusAr: 'المرحلة الحالية: استكمال الجاهزية والوثائق',
          nextMilestoneAr:
              'الخطوة التالية: مراجعة الجواز والتأشيرة وموعد التجمع',
          travelWindowAr: 'موعد السفر: تحدده الشركة المنظمة عند اعتماده',
          readinessLabelAr: 'جاهزية مبدئية',
          progress: 0.42)
      : const JourneyOverview(
          titleAr: 'رحلة الحاج من الاستعداد حتى العودة',
          subtitleAr:
              'متابعة مراحل الحج تحت الإشراف الحكومي وبالتنسيق مع الحملة المنظمة.',
          currentStatusAr: 'المرحلة الحالية: استكمال الجاهزية والوثائق',
          nextMilestoneAr:
              'الخطوة التالية: مراجعة الجواز، التطعيم، ونقطة التجمع',
          travelWindowAr: 'موعد السفر: تحدده الجهة المنظمة عند اعتماده رسميًا',
          readinessLabelAr: 'جاهزية مبدئية',
          progress: 0.42);

  @override
  Future<List<JourneyStep>> getJourneySteps() async =>
      _isUmrah ? _umrahJourneySteps : _hajjJourneySteps;

  @override
  Future<List<String>> getGuidanceItems() async => _isUmrah
      ? const [
          'الإحرام والنية والميقات',
          'الطواف وآدابه',
          'السعي بين الصفا والمروة',
          'الحلق أو التقصير والتحلل',
          'إرشادات السلامة والتنقل مع المجموعة'
        ]
      : const [
          'الإحرام والنية ومواقيت الإحرام',
          'الطواف والسعي وآدابهما',
          'الوقوف بعرفة وأعمال يوم عرفة',
          'المبيت بمزدلفة ومنى',
          'رمي الجمرات والهدي والحلق أو التقصير',
          'طواف الوداع وتنبيهات السفر'
        ];

  @override
  Future<List<String>> getFatwaItems() async => _isUmrah
      ? const [
          'ما محظورات الإحرام؟',
          'ما أحكام الطواف والسعي؟',
          'متى يتحلل المعتمر؟',
          'متى يجب سؤال المرشد؟'
        ]
      : const [
          'ما حكم من نسي واجبًا من واجبات الحج؟',
          'هل يجوز التوكيل في الرمي؟',
          'ما محظورات الإحرام؟',
          'متى يجوز التحلل؟',
          'متى يجب سؤال المرشد؟'
        ];

  @override
  Future<List<String>> getImportantContacts() async => _isUmrah
      ? const [
          'الطوارئ المحلي: حسب البلد الموجود فيه المعتمر',
          'مشرف الشركة أو المجموعة: أضفه من الإعدادات',
          'الدعم الميداني: تحدده الشركة المنظمة',
          'الإرشاد الشرعي: المرشد المعتمد',
          'المساعدة الصحية: أقرب نقطة طبية أو إسعاف'
        ]
      : const [
          'الطوارئ المحلي: حسب البلد الموجود فيه الحاج',
          'مشرف الحملة: أضفه من الإعدادات',
          'الدعم الميداني: تحدده الجهة المنظمة',
          'الإرشاد الشرعي: المرشد المعتمد',
          'المساعدة الصحية: أقرب نقطة طبية أو إسعاف'
        ];

  @override
  Future<List<String>> getUsefulLinks() async => const [
        'دليل مناسك الحج والعمرة',
        'إرشادات السلامة في السفر',
        'إرشادات صحية للحجاج والمعتمرين',
        'قائمة وثائق السفر',
        'تنبيهات التفويج والتنقل'
      ];
}

const _hajjJourneySteps = [
  JourneyStep(
      id: 'registration',
      titleAr: 'التسجيل والطلب',
      descriptionAr: 'متابعة الطلب عبر القنوات الرسمية.',
      status: JourneyStepStatus.completed,
      stageLabelAr: 'قبل السفر',
      dateLabelAr: 'مكتمل تجريبيًا',
      checklistItemsAr: [
        'التحقق من البيانات الأساسية',
        'تأكيد رقم الهاتف',
        'مراجعة بيانات المرافق'
      ],
      tipsAr: [
        'احتفظ بنسخة من بيانات الطلب.',
        'اتبع تعليمات الجهة الرسمية والحملة المعتمدة.'
      ],
      actionLabelAr: 'عرض بياناتي'),
  JourneyStep(
      id: 'documents',
      titleAr: 'الجواز والوثائق',
      descriptionAr: 'مراجعة الجواز والوثائق المطلوبة قبل السفر.',
      status: JourneyStepStatus.attention,
      stageLabelAr: 'قبل السفر',
      dateLabelAr: 'يتطلب مراجعة',
      checklistItemsAr: [
        'التأكد من صلاحية الجواز',
        'حفظ نسخ الوثائق',
        'مراجعة متطلبات الجهة المنظمة'
      ],
      tipsAr: ['احتفظ بالأصول في مكان آمن.'],
      actionLabelAr: 'قائمة الجاهزية'),
  JourneyStep(
      id: 'health',
      titleAr: 'الصحة والتطعيم',
      descriptionAr: 'متابعة المتطلبات الصحية والتطعيمات الرسمية.',
      status: JourneyStepStatus.current,
      stageLabelAr: 'قبل السفر',
      dateLabelAr: 'قيد المتابعة',
      checklistItemsAr: [
        'مراجعة المتطلبات الصحية',
        'تجهيز الأدوية',
        'حفظ الوصفات'
      ],
      tipsAr: ['اتبع التعليمات الصحية الرسمية.'],
      actionLabelAr: 'السلامة والصحة'),
  JourneyStep(
      id: 'departure',
      titleAr: 'التجمع والسفر',
      descriptionAr: 'متابعة نقطة التجمع ووقت التحرك مع الحملة.',
      status: JourneyStepStatus.upcoming,
      stageLabelAr: 'السفر',
      dateLabelAr: 'لاحقًا',
      checklistItemsAr: [
        'حفظ رقم المشرف',
        'مراجعة نقطة التجمع',
        'تجهيز الهاتف'
      ],
      tipsAr: ['التزم بتعليمات التفويج.'],
      actionLabelAr: 'هواتف ضرورية'),
  JourneyStep(
      id: 'rituals',
      titleAr: 'أداء مناسك الحج',
      descriptionAr: 'متابعة أعمال الحج وفق الإرشاد الشرعي والتنظيم الرسمي.',
      status: JourneyStepStatus.upcoming,
      stageLabelAr: 'أثناء الحج',
      dateLabelAr: 'لاحقًا',
      checklistItemsAr: [
        'مراجعة الطواف والسعي',
        'أعمال عرفة ومزدلفة ومنى',
        'سؤال المرشد عند الاشتباه'
      ],
      tipsAr: ['لا تعتمد على معلومات غير موثوقة.'],
      actionLabelAr: 'دليل المناسك'),
  JourneyStep(
      id: 'return_review',
      titleAr: 'العودة والتقييم',
      descriptionAr: 'تقييم الخدمات وتوثيق الملاحظات بعد العودة.',
      status: JourneyStepStatus.upcoming,
      stageLabelAr: 'بعد العودة',
      dateLabelAr: 'بعد الرحلة',
      checklistItemsAr: ['استكمال الاستبيان', 'تسجيل الملاحظات', 'حفظ الوثائق'],
      tipsAr: ['الملاحظات الدقيقة تساعد في تحسين الخدمة.'],
      actionLabelAr: 'استبيان الحج'),
];

const _umrahJourneySteps = [
  JourneyStep(
      id: 'booking_documents',
      titleAr: 'الحجز والوثائق',
      descriptionAr:
          'مراجعة برنامج العمرة والجواز والتأشيرة مع الشركة المنظمة.',
      status: JourneyStepStatus.completed,
      stageLabelAr: 'قبل السفر',
      dateLabelAr: 'مكتمل تجريبيًا',
      checklistItemsAr: [
        'مراجعة بيانات الجواز',
        'تأكيد برنامج الرحلة',
        'حفظ بيانات الشركة والمشرف'
      ],
      tipsAr: ['تعامل مع الشركة والقنوات الرسمية المعتمدة فقط.'],
      actionLabelAr: 'بيانات الرحلة'),
  JourneyStep(
      id: 'readiness',
      titleAr: 'الجاهزية للسفر',
      descriptionAr: 'تجهيز المتطلبات الصحية والحقيبة وموعد التجمع.',
      status: JourneyStepStatus.current,
      stageLabelAr: 'قبل السفر',
      dateLabelAr: 'قيد المتابعة',
      checklistItemsAr: [
        'مراجعة المتطلبات الصحية',
        'تجهيز الأدوية',
        'تأكيد موعد التجمع'
      ],
      tipsAr: ['تابع تحديثات الشركة المنظمة.'],
      actionLabelAr: 'قائمة الجاهزية'),
  JourneyStep(
      id: 'miqat_ihram',
      titleAr: 'الميقات والإحرام',
      descriptionAr: 'الاستعداد للإحرام والنية وفق مسار السفر.',
      status: JourneyStepStatus.upcoming,
      stageLabelAr: 'بدء النسك',
      dateLabelAr: 'لاحقًا',
      checklistItemsAr: [
        'معرفة الميقات',
        'مراجعة محظورات الإحرام',
        'سؤال المرشد'
      ],
      tipsAr: ['استعد قبل الميقات بوقت كافٍ.'],
      actionLabelAr: 'دليل الإحرام'),
  JourneyStep(
      id: 'tawaf',
      titleAr: 'الطواف',
      descriptionAr: 'أداء سبعة أشواط مع مراعاة التنظيم والسلامة.',
      status: JourneyStepStatus.upcoming,
      stageLabelAr: 'أثناء العمرة',
      dateLabelAr: 'لاحقًا',
      checklistItemsAr: [
        'اتبع تعليمات التنظيم',
        'تجنب المزاحمة',
        'توقف عند التعب'
      ],
      tipsAr: ['الأولوية للسلامة والرفق.'],
      actionLabelAr: 'دليل الطواف'),
  JourneyStep(
      id: 'sai',
      titleAr: 'السعي',
      descriptionAr: 'السعي بين الصفا والمروة وفق أحكام النسك.',
      status: JourneyStepStatus.upcoming,
      stageLabelAr: 'أثناء العمرة',
      dateLabelAr: 'لاحقًا',
      checklistItemsAr: ['ابدأ من الصفا', 'أكمل الأشواط', 'ابق مع المجموعة'],
      tipsAr: ['استخدم نقاط الراحة عند الحاجة.'],
      actionLabelAr: 'دليل السعي'),
  JourneyStep(
      id: 'halq',
      titleAr: 'الحلق أو التقصير',
      descriptionAr: 'إتمام النسك والتحلل بعد السعي.',
      status: JourneyStepStatus.upcoming,
      stageLabelAr: 'إتمام العمرة',
      dateLabelAr: 'لاحقًا',
      checklistItemsAr: [
        'تأكد من إتمام السعي',
        'أتم الحلق أو التقصير',
        'راجع موعد العودة'
      ],
      tipsAr: ['اسأل المرشد عند وجود حالة خاصة.'],
      actionLabelAr: 'إتمام النسك'),
  JourneyStep(
      id: 'return_review',
      titleAr: 'العودة والتقييم',
      descriptionAr: 'متابعة ترتيبات العودة وتقييم خدمات الرحلة.',
      status: JourneyStepStatus.upcoming,
      stageLabelAr: 'بعد العمرة',
      dateLabelAr: 'بعد الرحلة',
      checklistItemsAr: [
        'تأكيد موعد المغادرة',
        'مراجعة الأمتعة والوثائق',
        'تقييم الخدمة'
      ],
      tipsAr: ['أرسل الملاحظات التشغيلية للشركة المنظمة.'],
      actionLabelAr: 'تقييم العمرة'),
];
