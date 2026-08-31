enum NusukBridgeFeatureMode {
  guestDevelopment,
  nusukConnectedPreview,
  productionConnected,
}

extension NusukBridgeFeatureModeX on NusukBridgeFeatureMode {
  bool get isGuestDevelopment =>
      this == NusukBridgeFeatureMode.guestDevelopment;

  bool get isConnectedPreview =>
      this == NusukBridgeFeatureMode.nusukConnectedPreview;

  bool get isProductionTarget =>
      this == NusukBridgeFeatureMode.productionConnected;

  bool get expectsAuthenticatedIdentity => !isGuestDevelopment;

  String get labelAr {
    switch (this) {
      case NusukBridgeFeatureMode.guestDevelopment:
        return 'ضيف / تطوير محلي';
      case NusukBridgeFeatureMode.nusukConnectedPreview:
        return 'معاينة اتصال نسك';
      case NusukBridgeFeatureMode.productionConnected:
        return 'اتصال إنتاجي مستهدف';
    }
  }
}

sealed class NusukBridgeState<T> {
  const NusukBridgeState();
}

final class NusukBridgeLoading<T> extends NusukBridgeState<T> {
  const NusukBridgeLoading();
}

final class NusukBridgeData<T> extends NusukBridgeState<T> {
  const NusukBridgeData(this.value);

  final T value;
}

final class NusukBridgeEmpty<T> extends NusukBridgeState<T> {
  const NusukBridgeEmpty({this.messageAr});

  final String? messageAr;
}

final class NusukBridgeError<T> extends NusukBridgeState<T> {
  const NusukBridgeError({
    required this.messageAr,
    this.cause,
  });

  final String messageAr;
  final Object? cause;
}

final class NusukBridgeOffline<T> extends NusukBridgeState<T> {
  const NusukBridgeOffline({required this.messageAr});

  final String messageAr;
}

final class NusukBridgeNeedsLogin<T> extends NusukBridgeState<T> {
  const NusukBridgeNeedsLogin({required this.messageAr});

  final String messageAr;
}

final class NusukBridgeNeedsConsent<T> extends NusukBridgeState<T> {
  const NusukBridgeNeedsConsent({
    required this.messageAr,
    required this.consentKey,
  });

  final String messageAr;
  final String consentKey;
}
