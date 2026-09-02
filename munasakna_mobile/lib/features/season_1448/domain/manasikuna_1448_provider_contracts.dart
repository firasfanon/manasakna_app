import 'manasikuna_1448_models.dart';

abstract interface class PilgrimProfileProvider {
  String get providerId;

  Future<OfficialPilgrimSeed?> loadProfile({
    ActivationCredential? activation,
  });
}

abstract interface class CampaignOperationalProvider {
  String get providerId;

  Future<CampaignOperationalPack?> loadCampaignPack({
    required OfficialPilgrimSeed pilgrim,
    ActivationCredential? activation,
  });
}

enum OfficialServiceKind {
  permit,
  visa,
  booking,
  nusuk,
  other,
}

abstract interface class OfficialServiceHandoffProvider {
  Uri? officialServiceUri(OfficialServiceKind service);
}

/// Compatibility seam for a future officially authorized Nusuk integration.
///
/// No implementation is enabled by default in the 1448 standalone launch.
abstract interface class NusukCompatibilityProvider
    implements PilgrimProfileProvider, CampaignOperationalProvider {
  bool get isOfficiallyAvailable;
}
