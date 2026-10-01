enum ProductSurfaceState {
  productionReady,
  preproductionReady,
  syntheticOnly,
  deferred,
}

class ProductSurface {
  const ProductSurface({
    required this.id,
    required this.labelAr,
    required this.state,
    required this.truthNote,
  });

  final String id;
  final String labelAr;
  final ProductSurfaceState state;
  final String truthNote;
}

const phase12CoreProductSurfaces = <ProductSurface>[
  ProductSurface(
    id: 'home',
    labelAr: 'الرئيسية',
    state: ProductSurfaceState.preproductionReady,
    truthNote: 'واجهة المسافر الرئيسية دون بيانات إنتاجية.',
  ),
  ProductSurface(
    id: 'journey',
    labelAr: 'رحلتي',
    state: ProductSurfaceState.preproductionReady,
    truthNote: 'سياق رحلة حج/عمرة محكوم حسب مصدر الصلاحية.',
  ),
  ProductSurface(
    id: 'rituals',
    labelAr: 'دليل المناسك',
    state: ProductSurfaceState.preproductionReady,
    truthNote: 'محتوى إرشادي محلي؛ لا يمثل فتوى آلية.',
  ),
  ProductSurface(
    id: 'assistant',
    labelAr: 'المساعد',
    state: ProductSurfaceState.preproductionReady,
    truthNote: 'مساعد آمن ضمن حدود الإرشاد والتذكير.',
  ),
  ProductSurface(
    id: 'schedule',
    labelAr: 'المواعيد والتقويم',
    state: ProductSurfaceState.preproductionReady,
    truthNote: 'مواعيد محلية/اختبارية ما لم يعلن مصدر رسمي.',
  ),
  ProductSurface(
    id: 'documents',
    labelAr: 'الوثائق',
    state: ProductSurfaceState.preproductionReady,
    truthNote: 'محفظة محلية ضمن حدود الخصوصية.',
  ),
  ProductSurface(
    id: 'group',
    labelAr: 'المجموعة والمشرف',
    state: ProductSurfaceState.syntheticOnly,
    truthNote: 'تظهر بيانات مصرح بها أو بيانات اصطناعية معلنة فقط.',
  ),
  ProductSurface(
    id: 'notifications',
    labelAr: 'الإشعارات',
    state: ProductSurfaceState.preproductionReady,
    truthNote: 'إشعارات محلية ما لم يعلن مزود خارجي صراحةً.',
  ),
  ProductSurface(
    id: 'support',
    labelAr: 'الدعم والطوارئ',
    state: ProductSurfaceState.preproductionReady,
    truthNote: 'قنوات وأدلة مساعدة ضمن المصدر المتاح.',
  ),
  ProductSurface(
    id: 'complaints',
    labelAr: 'الشكاوى',
    state: ProductSurfaceState.preproductionReady,
    truthNote: 'متابعة محلية/اختبارية قبل الربط الرسمي.',
  ),
  ProductSurface(
    id: 'surveys',
    labelAr: 'الاستبيانات',
    state: ProductSurfaceState.preproductionReady,
    truthNote: 'تقييم غير إنتاجي ما لم يعلن مصدر خارجي.',
  ),
  ProductSurface(
    id: 'government-services',
    labelAr: 'الخدمات الحكومية',
    state: ProductSurfaceState.deferred,
    truthNote: 'أي خدمة حكومية حقيقية مؤجلة حتى تكامل رسمي مصرح.',
  ),
  ProductSurface(
    id: 'umrah-services',
    labelAr: 'خدمات العمرة',
    state: ProductSurfaceState.preproductionReady,
    truthNote: 'التجربة الداخلية جاهزة؛ التكامل التجاري الحقيقي منفصل.',
  ),
];

bool get phase12CoreSurfacesTruthfullyClassified =>
    phase12CoreProductSurfaces.every((surface) => surface.truthNote.isNotEmpty);
