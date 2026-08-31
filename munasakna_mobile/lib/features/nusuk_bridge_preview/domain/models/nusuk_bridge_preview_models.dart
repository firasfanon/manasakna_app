enum NusukPreviewEndpointStatus {
  localOnly,
  readyForApi,
  needsAuth,
  needsRls,
  blocked,
}

extension NusukPreviewEndpointStatusX on NusukPreviewEndpointStatus {
  String get labelAr {
    switch (this) {
      case NusukPreviewEndpointStatus.localOnly:
        return 'محلي الآن';
      case NusukPreviewEndpointStatus.readyForApi:
        return 'جاهز للعقد';
      case NusukPreviewEndpointStatus.needsAuth:
        return 'يتطلب دخولًا لاحقًا';
      case NusukPreviewEndpointStatus.needsRls:
        return 'يتطلب RLS';
      case NusukPreviewEndpointStatus.blocked:
        return 'مؤجل للإنتاج';
    }
  }
}

enum NusukPreviewPrivacyLevel {
  publicGuidance,
  personal,
  sensitive,
  locationBased,
  writeAudit,
}

extension NusukPreviewPrivacyLevelX on NusukPreviewPrivacyLevel {
  String get labelAr {
    switch (this) {
      case NusukPreviewPrivacyLevel.publicGuidance:
        return 'إرشادي عام';
      case NusukPreviewPrivacyLevel.personal:
        return 'بيانات شخصية';
      case NusukPreviewPrivacyLevel.sensitive:
        return 'حساس';
      case NusukPreviewPrivacyLevel.locationBased:
        return 'مرتبط بالموقع';
      case NusukPreviewPrivacyLevel.writeAudit:
        return 'كتابة مع تدقيق';
    }
  }
}

class NusukPreviewField {
  const NusukPreviewField({
    required this.name,
    required this.labelAr,
    required this.typeHint,
    required this.required,
    required this.sourceAr,
    required this.privacyLevel,
    this.notesAr,
  });

  final String name;
  final String labelAr;
  final String typeHint;
  final bool required;
  final String sourceAr;
  final NusukPreviewPrivacyLevel privacyLevel;
  final String? notesAr;
}

class NusukPreviewEndpoint {
  const NusukPreviewEndpoint({
    required this.id,
    required this.titleAr,
    required this.purposeAr,
    required this.method,
    required this.path,
    required this.screenConsumersAr,
    required this.status,
    required this.fields,
    required this.samplePayloadLines,
    required this.acceptanceRulesAr,
    required this.failureFallbackAr,
  });

  final String id;
  final String titleAr;
  final String purposeAr;
  final String method;
  final String path;
  final List<String> screenConsumersAr;
  final NusukPreviewEndpointStatus status;
  final List<NusukPreviewField> fields;
  final List<String> samplePayloadLines;
  final List<String> acceptanceRulesAr;
  final String failureFallbackAr;
}

class NusukPreviewGate {
  const NusukPreviewGate({
    required this.id,
    required this.titleAr,
    required this.ownerAr,
    required this.statusAr,
    required this.descriptionAr,
    required this.done,
  });

  final String id;
  final String titleAr;
  final String ownerAr;
  final String statusAr;
  final String descriptionAr;
  final bool done;
}
