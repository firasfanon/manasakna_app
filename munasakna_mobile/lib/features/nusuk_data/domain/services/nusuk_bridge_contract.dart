import '../models/nusuk_bridge_status.dart';

class NusukBridgeContractPlan {
  const NusukBridgeContractPlan._();

  static const contracts = <NusukBridgeContract>[
    NusukBridgeContract(
      id: 'pilgrim_profile',
      titleAr: 'ملف الحاج',
      descriptionAr: 'عقد القراءة الأول لملف الحاج عند تفعيل تسجيل الدخول لاحقًا، ويغذي بياناتي والبطاقة الرقمية ورحلتي.',
      requiredFieldsAr: ['pilgrim_id', 'full_name_ar', 'national_id_masked', 'phone', 'company_name', 'group_name', 'status'],
      endpointHint: '/nusuk/me/profile',
      mode: NusukBridgeMode.readyForApi,
    ),
    NusukBridgeContract(
      id: 'journey_status',
      titleAr: 'حالة الرحلة',
      descriptionAr: 'عقد يربط مراحل الرحلة بحالة الطلب والوثائق والصحة والتفويج دون إظهار بيانات حساسة في وضع الضيف.',
      requiredFieldsAr: ['season_id', 'application_status', 'readiness_score', 'current_stage', 'next_action', 'last_updated_at'],
      endpointHint: '/nusuk/me/journey',
      mode: NusukBridgeMode.readyForApi,
    ),
    NusukBridgeContract(
      id: 'field_contacts',
      titleAr: 'المشرف والهواتف',
      descriptionAr: 'عقد تشغيلي للمشرف والمرشد والطوارئ، مع أولوية للاتصال والموقع عند الحاجة فقط.',
      requiredFieldsAr: ['supervisor_name', 'supervisor_phone', 'guide_phone', 'emergency_phone', 'assembly_points'],
      endpointHint: '/nusuk/me/contacts',
      mode: NusukBridgeMode.readyForApi,
    ),
    NusukBridgeContract(
      id: 'feedback_and_complaints',
      titleAr: 'الشكاوى والاستبيان',
      descriptionAr: 'عقد كتابة مؤجل لحين تفعيل المصادقة، ويحتاج سجل تدقيق وربطًا بالمرحلة والخدمة والجهة المعنية.',
      requiredFieldsAr: ['category', 'stage_id', 'priority', 'message', 'attachments_meta', 'audit_actor'],
      endpointHint: '/nusuk/me/feedback',
      mode: NusukBridgeMode.authenticated,
    ),
  ];

  static const gates = <NusukBetaGate>[
    NusukBetaGate(
      id: 'no_login_dev_mode',
      titleAr: 'وضع التطوير بلا تسجيل دخول',
      descriptionAr: 'يبقى التطبيق في وضع الضيف حتى اكتمال قاعدة بيانات نسك ومتطلبات الربط.',
      isComplete: true,
    ),
    NusukBetaGate(
      id: 'knowledge_guardrails',
      titleAr: 'حوكمة المعرفة والمساعد',
      descriptionAr: 'المساعد يجيب من مصفوفة الحج وFAQ فقط ويوجه للجهات المختصة عند المسائل الحساسة.',
      isComplete: true,
    ),
    NusukBetaGate(
      id: 'visual_consistency',
      titleAr: 'اتساق الهوية والواجهات',
      descriptionAr: 'تم تثبيت اللون الأخضر/الذهبي والبطاقات والشريط السفلي وواجهات الصفحات الداخلية.',
      isComplete: true,
    ),
    NusukBetaGate(
      id: 'server_contracts',
      titleAr: 'عقود الربط مع نسك',
      descriptionAr: 'تم تجهيز الحقول والاتجاه العام، ويبقى تنفيذ API وRLS والمصادقة لاحقًا.',
      isComplete: false,
    ),
    NusukBetaGate(
      id: 'scholar_approval',
      titleAr: 'اعتماد اللجنة الشرعية',
      descriptionAr: 'المحتوى الشرعي التفصيلي يحتاج اعتمادًا رسميًا قبل نشر الإنتاج.',
      isComplete: false,
    ),
  ];
}
