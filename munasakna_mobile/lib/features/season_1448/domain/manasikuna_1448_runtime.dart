import 'manasikuna_1448_models.dart';
import 'manasikuna_1448_provider_contracts.dart';

class Manasikuna1448RuntimeResolution {
  const Manasikuna1448RuntimeResolution({
    required this.requestedMode,
    required this.effectiveMode,
    required this.profileProviderId,
    this.campaignProviderId,
    this.fallbackReasonCode,
  });

  final ManasikunaIntegrationMode requestedMode;
  final ManasikunaIntegrationMode effectiveMode;
  final String profileProviderId;
  final String? campaignProviderId;
  final String? fallbackReasonCode;

  bool get usedFallback => requestedMode != effectiveMode;
}

class Manasikuna1448ResolvedContext {
  const Manasikuna1448ResolvedContext({
    required this.profile,
    required this.campaignPack,
    required this.resolution,
  });

  final OfficialPilgrimSeed? profile;
  final CampaignOperationalPack? campaignPack;
  final Manasikuna1448RuntimeResolution resolution;
}

class Manasikuna1448Runtime {
  const Manasikuna1448Runtime({
    required this.standaloneProfileProvider,
    this.campaignProfileProvider,
    this.campaignOperationalProvider,
    this.nusukProvider,
    this.requestedMode = ManasikunaIntegrationMode.standalone,
  });

  final PilgrimProfileProvider standaloneProfileProvider;
  final PilgrimProfileProvider? campaignProfileProvider;
  final CampaignOperationalProvider? campaignOperationalProvider;
  final NusukCompatibilityProvider? nusukProvider;
  final ManasikunaIntegrationMode requestedMode;

  Future<Manasikuna1448ResolvedContext> resolve({
    ActivationCredential? activation,
    DateTime? now,
  }) async {
    final clock = (now ?? DateTime.now()).toUtc();

    if (!requestedMode.isStandalone) {
      if (activation == null) {
        return _resolveStandalone(fallbackReasonCode: 'activation_missing');
      }
      if (!activation.isValidAt(clock)) {
        return _resolveStandalone(
          fallbackReasonCode: 'activation_expired_or_not_yet_valid',
        );
      }
    }

    switch (requestedMode) {
      case ManasikunaIntegrationMode.standalone:
        return _resolveStandalone();
      case ManasikunaIntegrationMode.campaignConnected:
        return _resolveCampaign(activation: activation!);
      case ManasikunaIntegrationMode.nusukConnected:
        return _resolveNusukThenFallback(activation: activation!);
    }
  }

  Future<Manasikuna1448ResolvedContext> _resolveStandalone({
    String? fallbackReasonCode,
  }) async {
    final profile = await standaloneProfileProvider.loadProfile();
    return Manasikuna1448ResolvedContext(
      profile: profile,
      campaignPack: null,
      resolution: Manasikuna1448RuntimeResolution(
        requestedMode: requestedMode,
        effectiveMode: ManasikunaIntegrationMode.standalone,
        profileProviderId: standaloneProfileProvider.providerId,
        fallbackReasonCode: fallbackReasonCode,
      ),
    );
  }

  Future<Manasikuna1448ResolvedContext> _resolveCampaign({
    required ActivationCredential activation,
    String? fallbackReasonCode,
  }) async {
    final profileProvider = campaignProfileProvider;
    final operationalProvider = campaignOperationalProvider;

    if (profileProvider == null || operationalProvider == null) {
      return _resolveStandalone(
        fallbackReasonCode: _fallbackTrail(
          fallbackReasonCode,
          'campaign_provider_unavailable',
        ),
      );
    }

    OfficialPilgrimSeed? profile;
    try {
      profile = await profileProvider.loadProfile(activation: activation);
    } catch (_) {
      return _resolveStandalone(
        fallbackReasonCode: _fallbackTrail(
          fallbackReasonCode,
          'campaign_profile_provider_error',
        ),
      );
    }

    if (profile == null) {
      return _resolveStandalone(
        fallbackReasonCode: _fallbackTrail(
          fallbackReasonCode,
          'campaign_profile_missing',
        ),
      );
    }

    if (!profile.isActivationEligible) {
      return _resolveStandalone(
        fallbackReasonCode: _fallbackTrail(
          fallbackReasonCode,
          'campaign_profile_not_approved',
        ),
      );
    }

    CampaignOperationalPack? pack;
    try {
      pack = await operationalProvider.loadCampaignPack(
        pilgrim: profile,
        activation: activation,
      );
    } catch (_) {
      return _resolveStandalone(
        fallbackReasonCode: _fallbackTrail(
          fallbackReasonCode,
          'campaign_operational_provider_error',
        ),
      );
    }

    if (pack == null) {
      return _resolveStandalone(
        fallbackReasonCode: _fallbackTrail(
          fallbackReasonCode,
          'campaign_pack_missing',
        ),
      );
    }

    if (!_campaignPackMatchesContext(
      profile: profile,
      pack: pack,
      activation: activation,
    )) {
      return _resolveStandalone(
        fallbackReasonCode: _fallbackTrail(
          fallbackReasonCode,
          'campaign_pack_context_mismatch',
        ),
      );
    }

    return Manasikuna1448ResolvedContext(
      profile: profile,
      campaignPack: pack,
      resolution: Manasikuna1448RuntimeResolution(
        requestedMode: requestedMode,
        effectiveMode: ManasikunaIntegrationMode.campaignConnected,
        profileProviderId: profileProvider.providerId,
        campaignProviderId: operationalProvider.providerId,
        fallbackReasonCode: fallbackReasonCode,
      ),
    );
  }

  Future<Manasikuna1448ResolvedContext> _resolveNusukThenFallback({
    required ActivationCredential activation,
  }) async {
    final provider = nusukProvider;

    if (provider == null || !provider.isOfficiallyAvailable) {
      return _resolveCampaign(
        activation: activation,
        fallbackReasonCode: 'nusuk_provider_not_officially_available',
      );
    }

    try {
      final profile = await provider.loadProfile(activation: activation);

      if (profile == null) {
        return _resolveCampaign(
          activation: activation,
          fallbackReasonCode: 'nusuk_profile_missing',
        );
      }

      if (!profile.isActivationEligible) {
        return _resolveCampaign(
          activation: activation,
          fallbackReasonCode: 'nusuk_profile_not_approved',
        );
      }

      final pack = await provider.loadCampaignPack(
        pilgrim: profile,
        activation: activation,
      );

      if (pack == null) {
        return _resolveCampaign(
          activation: activation,
          fallbackReasonCode: 'nusuk_campaign_pack_missing',
        );
      }

      if (!_campaignPackMatchesContext(
        profile: profile,
        pack: pack,
        activation: activation,
      )) {
        return _resolveCampaign(
          activation: activation,
          fallbackReasonCode: 'nusuk_campaign_pack_context_mismatch',
        );
      }

      return Manasikuna1448ResolvedContext(
        profile: profile,
        campaignPack: pack,
        resolution: Manasikuna1448RuntimeResolution(
          requestedMode: requestedMode,
          effectiveMode: ManasikunaIntegrationMode.nusukConnected,
          profileProviderId: provider.providerId,
          campaignProviderId: provider.providerId,
        ),
      );
    } catch (_) {
      return _resolveCampaign(
        activation: activation,
        fallbackReasonCode: 'nusuk_provider_error',
      );
    }
  }

  bool _campaignPackMatchesContext({
    required OfficialPilgrimSeed profile,
    required CampaignOperationalPack pack,
    required ActivationCredential activation,
  }) {
    final profileCampaign = profile.campaignReference?.trim();
    if (profileCampaign != null &&
        profileCampaign.isNotEmpty &&
        pack.campaignReference.trim() != profileCampaign) {
      return false;
    }

    final profileGroup = profile.groupReference?.trim();
    final packGroup = pack.groupReference?.trim();
    if (profileGroup != null &&
        profileGroup.isNotEmpty &&
        packGroup != null &&
        packGroup.isNotEmpty &&
        packGroup != profileGroup) {
      return false;
    }

    final activationPackId = activation.packId?.trim();
    if (activationPackId != null &&
        activationPackId.isNotEmpty &&
        pack.packId.trim() != activationPackId) {
      return false;
    }

    return true;
  }

  String _fallbackTrail(String? priorReason, String currentReason) {
    if (priorReason == null || priorReason.isEmpty) {
      return currentReason;
    }
    return '$priorReason>$currentReason';
  }
}
