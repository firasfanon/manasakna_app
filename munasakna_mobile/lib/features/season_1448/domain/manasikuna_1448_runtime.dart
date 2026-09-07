import 'dart:async';

import 'manasikuna_1448_contract_policy.dart';
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
  bool get isDegraded => usedFallback || fallbackReasonCode != null;
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
  Manasikuna1448Runtime({
    required this.standaloneProfileProvider,
    this.campaignProfileProvider,
    this.campaignOperationalProvider,
    this.nusukProvider,
    this.requestedMode = ManasikunaIntegrationMode.standalone,
    this.waveCContractPolicy,
    this.connectedProviderTimeout = const Duration(seconds: 5),
  }) {
    if (connectedProviderTimeout.inMicroseconds <= 0) {
      throw ArgumentError.value(
        connectedProviderTimeout,
        'connectedProviderTimeout',
        'must be greater than zero',
      );
    }
  }

  final PilgrimProfileProvider standaloneProfileProvider;
  final PilgrimProfileProvider? campaignProfileProvider;
  final CampaignOperationalProvider? campaignOperationalProvider;
  final NusukCompatibilityProvider? nusukProvider;
  final ManasikunaIntegrationMode requestedMode;

  /// Null preserves the historical provider seam for legacy tests/standalone
  /// callers. The actual 1448 activation controller enables this policy.
  final Manasikuna1448WaveCContractPolicy? waveCContractPolicy;

  /// Bounded connected-provider timeout. Timeout is classified separately from
  /// provider exceptions and degrades fail-closed to the safer fallback.
  final Duration connectedProviderTimeout;

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
        return _resolveCampaign(
          activation: activation!,
          clock: clock,
        );
      case ManasikunaIntegrationMode.nusukConnected:
        return _resolveNusukThenFallback(
          activation: activation!,
          clock: clock,
        );
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
    required DateTime clock,
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
      profile = await profileProvider
          .loadProfile(activation: activation)
          .timeout(connectedProviderTimeout);
    } on TimeoutException {
      return _resolveStandalone(
        fallbackReasonCode: _fallbackTrail(
          fallbackReasonCode,
          'campaign_profile_provider_timeout',
        ),
      );
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

    final profileContractViolation =
        waveCContractPolicy?.profileViolation(profile, clock);
    if (profileContractViolation != null) {
      return _resolveStandalone(
        fallbackReasonCode: _fallbackTrail(
          fallbackReasonCode,
          'campaign_profile_contract_$profileContractViolation',
        ),
      );
    }

    CampaignOperationalPack? pack;
    try {
      pack = await operationalProvider
          .loadCampaignPack(
            pilgrim: profile,
            activation: activation,
          )
          .timeout(connectedProviderTimeout);
    } on TimeoutException {
      return _resolveStandalone(
        fallbackReasonCode: _fallbackTrail(
          fallbackReasonCode,
          'campaign_operational_provider_timeout',
        ),
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

    final packContractViolation = waveCContractPolicy?.campaignPackViolation(
      profile: profile,
      pack: pack,
      moment: clock,
    );
    if (packContractViolation != null) {
      return _resolveStandalone(
        fallbackReasonCode: _fallbackTrail(
          fallbackReasonCode,
          'campaign_pack_contract_$packContractViolation',
        ),
      );
    }

    final activationContractViolation =
        waveCContractPolicy?.activationViolation(
      activation: activation,
      profile: profile,
      pack: pack,
    );
    if (activationContractViolation != null) {
      return _resolveStandalone(
        fallbackReasonCode: _fallbackTrail(
          fallbackReasonCode,
          'campaign_activation_contract_$activationContractViolation',
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
    required DateTime clock,
  }) async {
    final provider = nusukProvider;

    if (provider == null || !provider.isOfficiallyAvailable) {
      return _resolveCampaign(
        activation: activation,
        clock: clock,
        fallbackReasonCode: 'nusuk_provider_not_officially_available',
      );
    }

    try {
      final profile = await provider
          .loadProfile(activation: activation)
          .timeout(connectedProviderTimeout);

      if (profile == null) {
        return _resolveCampaign(
          activation: activation,
          clock: clock,
          fallbackReasonCode: 'nusuk_profile_missing',
        );
      }

      if (!profile.isActivationEligible) {
        return _resolveCampaign(
          activation: activation,
          clock: clock,
          fallbackReasonCode: 'nusuk_profile_not_approved',
        );
      }

      final profileContractViolation =
          waveCContractPolicy?.profileViolation(profile, clock);
      if (profileContractViolation != null) {
        return _resolveCampaign(
          activation: activation,
          clock: clock,
          fallbackReasonCode:
              'nusuk_profile_contract_$profileContractViolation',
        );
      }

      final pack = await provider
          .loadCampaignPack(
            pilgrim: profile,
            activation: activation,
          )
          .timeout(connectedProviderTimeout);

      if (pack == null) {
        return _resolveCampaign(
          activation: activation,
          clock: clock,
          fallbackReasonCode: 'nusuk_campaign_pack_missing',
        );
      }

      final packContractViolation = waveCContractPolicy?.campaignPackViolation(
        profile: profile,
        pack: pack,
        moment: clock,
      );
      if (packContractViolation != null) {
        return _resolveCampaign(
          activation: activation,
          clock: clock,
          fallbackReasonCode:
              'nusuk_campaign_pack_contract_$packContractViolation',
        );
      }

      final activationContractViolation =
          waveCContractPolicy?.activationViolation(
        activation: activation,
        profile: profile,
        pack: pack,
      );
      if (activationContractViolation != null) {
        return _resolveCampaign(
          activation: activation,
          clock: clock,
          fallbackReasonCode:
              'nusuk_activation_contract_$activationContractViolation',
        );
      }

      if (!_campaignPackMatchesContext(
        profile: profile,
        pack: pack,
        activation: activation,
      )) {
        return _resolveCampaign(
          activation: activation,
          clock: clock,
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
    } on TimeoutException {
      return _resolveCampaign(
        activation: activation,
        clock: clock,
        fallbackReasonCode: 'nusuk_provider_timeout',
      );
    } catch (_) {
      return _resolveCampaign(
        activation: activation,
        clock: clock,
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
