enum NusukBridgeMode {
  localDevelopment,
  readyForApi,
  authenticated,
}

class NusukBridgeContract {
  const NusukBridgeContract({
    required this.id,
    required this.titleAr,
    required this.descriptionAr,
    required this.requiredFieldsAr,
    required this.endpointHint,
    required this.mode,
  });

  final String id;
  final String titleAr;
  final String descriptionAr;
  final List<String> requiredFieldsAr;
  final String endpointHint;
  final NusukBridgeMode mode;

  String get modeLabelAr {
    switch (mode) {
      case NusukBridgeMode.localDevelopment:
        return 'محلي الآن';
      case NusukBridgeMode.readyForApi:
        return 'جاهز للعقد';
      case NusukBridgeMode.authenticated:
        return 'بعد الدخول';
    }
  }
}

class NusukBetaGate {
  const NusukBetaGate({
    required this.id,
    required this.titleAr,
    required this.descriptionAr,
    required this.isComplete,
  });

  final String id;
  final String titleAr;
  final String descriptionAr;
  final bool isComplete;
}
