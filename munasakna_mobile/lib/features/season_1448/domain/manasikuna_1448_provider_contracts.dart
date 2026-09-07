import 'manasikuna_1448_models.dart';

/// Provider seam for an OFFICIAL_PILGRIM_SEED.
///
/// Legacy providers may still return a seed without contract metadata. When the
/// Wave C policy is enabled, connected runtime rejects such a result fail-closed.
abstract interface class PilgrimProfileProvider {
  String get providerId;

  Future<OfficialPilgrimSeed?> loadProfile({
    ActivationCredential? activation,
  });
}

/// Provider seam for a CAMPAIGN_OPERATIONAL_PACK.
///
/// Wave C does not connect a real endpoint. The current implementation uses
/// synthetic fixtures carrying version/provenance/approval/integrity metadata.
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
/// REAL_NUSUK remains NO until a separate explicit authorization.
abstract interface class NusukCompatibilityProvider
    implements PilgrimProfileProvider, CampaignOperationalProvider {
  bool get isOfficiallyAvailable;
}
