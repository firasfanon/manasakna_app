import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/features/season_1448/domain/manasikuna_1448_models.dart';
import 'package:munasakna_mobile/features/season_1448/domain/manasikuna_1448_provider_contracts.dart';
import 'package:munasakna_mobile/features/season_1448/domain/manasikuna_1448_runtime.dart';

void main() {
  final now = DateTime.utc(2026, 9, 2, 12);
  final validActivation = ActivationCredential(
    opaqueToken: 'opaque-test-token-001',
    issuedAt: now.subtract(const Duration(hours: 1)),
    expiresAt: now.add(const Duration(hours: 1)),
    packId: 'pack-synthetic-001',
  );

  group('Manasikuna 1448 standalone foundation', () {
    test('standalone is the default and never calls Nusuk', () async {
      final standalone = _FakeProfileProvider(
        providerId: 'local.synthetic',
        profile: _approvedSeed('LOCAL-001'),
      );
      final nusuk = _FakeNusukProvider(
        available: true,
        profile: _approvedSeed('NUSUK-001'),
        pack: _campaignPack(),
      );

      final runtime = Manasikuna1448Runtime(
        standaloneProfileProvider: standalone,
        nusukProvider: nusuk,
      );

      final result = await runtime.resolve(now: now);

      expect(
        result.resolution.effectiveMode,
        ManasikunaIntegrationMode.standalone,
      );
      expect(result.profile?.officialReference, 'LOCAL-001');
      expect(result.campaignPack, isNull);
      expect(result.resolution.fallbackReasonCode, isNull);
      expect(nusuk.profileCalls, 0);
      expect(nusuk.packCalls, 0);
    });

    test('campaign mode uses authorized seed plus matching operational pack',
        () async {
      final standalone = _FakeProfileProvider(
        providerId: 'local.synthetic',
        profile: _approvedSeed('LOCAL-001'),
      );
      final campaignProfile = _FakeProfileProvider(
        providerId: 'official-seed.synthetic',
        profile: _approvedSeed('OFFICIAL-001'),
      );
      final campaignPack = _FakeCampaignProvider(pack: _campaignPack());

      final runtime = Manasikuna1448Runtime(
        standaloneProfileProvider: standalone,
        campaignProfileProvider: campaignProfile,
        campaignOperationalProvider: campaignPack,
        requestedMode: ManasikunaIntegrationMode.campaignConnected,
      );

      final result = await runtime.resolve(
        activation: validActivation,
        now: now,
      );

      expect(
        result.resolution.effectiveMode,
        ManasikunaIntegrationMode.campaignConnected,
      );
      expect(result.profile?.officialReference, 'OFFICIAL-001');
      expect(result.campaignPack?.packId, 'pack-synthetic-001');
      expect(result.resolution.usedFallback, isFalse);
      expect(result.resolution.fallbackReasonCode, isNull);
    });

    test(
        'missing activation fails closed before connected providers are called',
        () async {
      final standalone = _FakeProfileProvider(
        providerId: 'local.synthetic',
        profile: _approvedSeed('LOCAL-001'),
      );
      final campaignProfile = _FakeProfileProvider(
        providerId: 'official-seed.synthetic',
        profile: _approvedSeed('OFFICIAL-001'),
      );
      final campaignPack = _FakeCampaignProvider(pack: _campaignPack());

      final runtime = Manasikuna1448Runtime(
        standaloneProfileProvider: standalone,
        campaignProfileProvider: campaignProfile,
        campaignOperationalProvider: campaignPack,
        requestedMode: ManasikunaIntegrationMode.campaignConnected,
      );

      final result = await runtime.resolve(now: now);

      expect(
        result.resolution.effectiveMode,
        ManasikunaIntegrationMode.standalone,
      );
      expect(result.resolution.fallbackReasonCode, 'activation_missing');
      expect(campaignProfile.calls, 0);
      expect(campaignPack.calls, 0);
    });

    test('expired activation fails closed to standalone', () async {
      final standalone = _FakeProfileProvider(
        providerId: 'local.synthetic',
        profile: _approvedSeed('LOCAL-001'),
      );
      final campaignProfile = _FakeProfileProvider(
        providerId: 'official-seed.synthetic',
        profile: _approvedSeed('OFFICIAL-001'),
      );
      final campaignPack = _FakeCampaignProvider(pack: _campaignPack());
      final expired = ActivationCredential(
        opaqueToken: 'opaque-expired-token',
        issuedAt: now.subtract(const Duration(days: 2)),
        expiresAt: now.subtract(const Duration(days: 1)),
      );

      final runtime = Manasikuna1448Runtime(
        standaloneProfileProvider: standalone,
        campaignProfileProvider: campaignProfile,
        campaignOperationalProvider: campaignPack,
        requestedMode: ManasikunaIntegrationMode.campaignConnected,
      );

      final result = await runtime.resolve(activation: expired, now: now);

      expect(
        result.resolution.effectiveMode,
        ManasikunaIntegrationMode.standalone,
      );
      expect(
        result.resolution.fallbackReasonCode,
        'activation_expired_or_not_yet_valid',
      );
      expect(campaignProfile.calls, 0);
      expect(campaignPack.calls, 0);
    });

    test(
        'missing Nusuk provider falls back to campaign without blocking launch',
        () async {
      final standalone = _FakeProfileProvider(
        providerId: 'local.synthetic',
        profile: _approvedSeed('LOCAL-001'),
      );
      final campaignProfile = _FakeProfileProvider(
        providerId: 'official-seed.synthetic',
        profile: _approvedSeed('OFFICIAL-001'),
      );
      final campaignPack = _FakeCampaignProvider(pack: _campaignPack());

      final runtime = Manasikuna1448Runtime(
        standaloneProfileProvider: standalone,
        campaignProfileProvider: campaignProfile,
        campaignOperationalProvider: campaignPack,
        requestedMode: ManasikunaIntegrationMode.nusukConnected,
      );

      final result = await runtime.resolve(
        activation: validActivation,
        now: now,
      );

      expect(
        result.resolution.effectiveMode,
        ManasikunaIntegrationMode.campaignConnected,
      );
      expect(
        result.resolution.fallbackReasonCode,
        'nusuk_provider_not_officially_available',
      );
      expect(result.profile?.officialReference, 'OFFICIAL-001');
      expect(result.resolution.usedFallback, isTrue);
    });

    test('unavailable Nusuk provider is not called and falls back safely',
        () async {
      final standalone = _FakeProfileProvider(
        providerId: 'local.synthetic',
        profile: _approvedSeed('LOCAL-001'),
      );
      final campaignProfile = _FakeProfileProvider(
        providerId: 'official-seed.synthetic',
        profile: _approvedSeed('OFFICIAL-001'),
      );
      final campaignPack = _FakeCampaignProvider(pack: _campaignPack());
      final nusuk = _FakeNusukProvider(
        available: false,
        profile: _approvedSeed('NUSUK-001'),
        pack: _campaignPack(),
      );

      final runtime = Manasikuna1448Runtime(
        standaloneProfileProvider: standalone,
        campaignProfileProvider: campaignProfile,
        campaignOperationalProvider: campaignPack,
        nusukProvider: nusuk,
        requestedMode: ManasikunaIntegrationMode.nusukConnected,
      );

      final result = await runtime.resolve(
        activation: validActivation,
        now: now,
      );

      expect(
        result.resolution.effectiveMode,
        ManasikunaIntegrationMode.campaignConnected,
      );
      expect(nusuk.profileCalls, 0);
      expect(nusuk.packCalls, 0);
    });

    test('non-approved official seed cannot activate campaign context',
        () async {
      final standalone = _FakeProfileProvider(
        providerId: 'local.synthetic',
        profile: _approvedSeed('LOCAL-001'),
      );
      final campaignProfile = _FakeProfileProvider(
        providerId: 'official-seed.synthetic',
        profile: OfficialPilgrimSeed(
          officialReference: 'WAIT-001',
          fullNameAr: 'حاج تجريبي على قائمة الانتظار',
          acceptanceStatus: OfficialPilgrimAcceptanceStatus.waitlisted,
          sourceAuthority: 'authorized-source.synthetic',
          sourceRevision: 'rev-synthetic-1',
          effectiveAt: now,
        ),
      );
      final campaignPack = _FakeCampaignProvider(pack: _campaignPack());

      final runtime = Manasikuna1448Runtime(
        standaloneProfileProvider: standalone,
        campaignProfileProvider: campaignProfile,
        campaignOperationalProvider: campaignPack,
        requestedMode: ManasikunaIntegrationMode.campaignConnected,
      );

      final result = await runtime.resolve(
        activation: validActivation,
        now: now,
      );

      expect(
        result.resolution.effectiveMode,
        ManasikunaIntegrationMode.standalone,
      );
      expect(
        result.resolution.fallbackReasonCode,
        'campaign_profile_not_approved',
      );
      expect(campaignPack.calls, 0);
    });

    test('campaign profile provider exception falls back to standalone',
        () async {
      final runtime = Manasikuna1448Runtime(
        standaloneProfileProvider: _FakeProfileProvider(
          providerId: 'local.synthetic',
          profile: _approvedSeed('LOCAL-001'),
        ),
        campaignProfileProvider: _FakeProfileProvider(
          providerId: 'official-seed.synthetic',
          profile: null,
          error: StateError('synthetic profile failure'),
        ),
        campaignOperationalProvider:
            _FakeCampaignProvider(pack: _campaignPack()),
        requestedMode: ManasikunaIntegrationMode.campaignConnected,
      );

      final result =
          await runtime.resolve(activation: validActivation, now: now);

      expect(
        result.resolution.effectiveMode,
        ManasikunaIntegrationMode.standalone,
      );
      expect(
        result.resolution.fallbackReasonCode,
        'campaign_profile_provider_error',
      );
    });

    test('campaign operational provider exception falls back to standalone',
        () async {
      final runtime = Manasikuna1448Runtime(
        standaloneProfileProvider: _FakeProfileProvider(
          providerId: 'local.synthetic',
          profile: _approvedSeed('LOCAL-001'),
        ),
        campaignProfileProvider: _FakeProfileProvider(
          providerId: 'official-seed.synthetic',
          profile: _approvedSeed('OFFICIAL-001'),
        ),
        campaignOperationalProvider: _FakeCampaignProvider(
          pack: null,
          error: StateError('synthetic operational failure'),
        ),
        requestedMode: ManasikunaIntegrationMode.campaignConnected,
      );

      final result =
          await runtime.resolve(activation: validActivation, now: now);

      expect(
        result.resolution.effectiveMode,
        ManasikunaIntegrationMode.standalone,
      );
      expect(
        result.resolution.fallbackReasonCode,
        'campaign_operational_provider_error',
      );
    });

    test('campaign reference mismatch fails closed to standalone', () async {
      final mismatchPack = _campaignPack(
        campaignReference: 'other-campaign',
      );
      final runtime = _campaignRuntime(pack: mismatchPack);

      final result =
          await runtime.resolve(activation: validActivation, now: now);

      expect(
        result.resolution.effectiveMode,
        ManasikunaIntegrationMode.standalone,
      );
      expect(
        result.resolution.fallbackReasonCode,
        'campaign_pack_context_mismatch',
      );
    });

    test('activation packId mismatch fails closed to standalone', () async {
      final mismatchedActivation = ActivationCredential(
        opaqueToken: 'opaque-other-pack',
        issuedAt: now.subtract(const Duration(hours: 1)),
        expiresAt: now.add(const Duration(hours: 1)),
        packId: 'pack-other',
      );
      final runtime = _campaignRuntime(pack: _campaignPack());

      final result = await runtime.resolve(
        activation: mismatchedActivation,
        now: now,
      );

      expect(
        result.resolution.effectiveMode,
        ManasikunaIntegrationMode.standalone,
      );
      expect(
        result.resolution.fallbackReasonCode,
        'campaign_pack_context_mismatch',
      );
    });

    test('available Nusuk with missing pack falls back to campaign', () async {
      final runtime = _nusukRuntime(
        nusuk: _FakeNusukProvider(
          available: true,
          profile: _approvedSeed('NUSUK-001'),
          pack: null,
        ),
      );

      final result =
          await runtime.resolve(activation: validActivation, now: now);

      expect(
        result.resolution.effectiveMode,
        ManasikunaIntegrationMode.campaignConnected,
      );
      expect(
        result.resolution.fallbackReasonCode,
        'nusuk_campaign_pack_missing',
      );
    });

    test('available Nusuk with context-mismatched pack falls back to campaign',
        () async {
      final runtime = _nusukRuntime(
        nusuk: _FakeNusukProvider(
          available: true,
          profile: _approvedSeed('NUSUK-001'),
          pack: _campaignPack(campaignReference: 'wrong-campaign'),
        ),
      );

      final result =
          await runtime.resolve(activation: validActivation, now: now);

      expect(
        result.resolution.effectiveMode,
        ManasikunaIntegrationMode.campaignConnected,
      );
      expect(
        result.resolution.fallbackReasonCode,
        'nusuk_campaign_pack_context_mismatch',
      );
    });

    test('Nusuk provider exception falls back to campaign and preserves reason',
        () async {
      final runtime = _nusukRuntime(
        nusuk: _FakeNusukProvider(
          available: true,
          profile: null,
          pack: null,
          profileError: StateError('synthetic Nusuk failure'),
        ),
      );

      final result =
          await runtime.resolve(activation: validActivation, now: now);

      expect(
        result.resolution.effectiveMode,
        ManasikunaIntegrationMode.campaignConnected,
      );
      expect(result.resolution.fallbackReasonCode, 'nusuk_provider_error');
    });

    test('blank activation token is rejected outside assert semantics', () {
      expect(
        () => ActivationCredential(
          opaqueToken: '   ',
          issuedAt: now,
          expiresAt: now.add(const Duration(hours: 1)),
        ),
        throwsArgumentError,
      );
    });
  });
}

Manasikuna1448Runtime _campaignRuntime({
  required CampaignOperationalPack pack,
}) {
  return Manasikuna1448Runtime(
    standaloneProfileProvider: _FakeProfileProvider(
      providerId: 'local.synthetic',
      profile: _approvedSeed('LOCAL-001'),
    ),
    campaignProfileProvider: _FakeProfileProvider(
      providerId: 'official-seed.synthetic',
      profile: _approvedSeed('OFFICIAL-001'),
    ),
    campaignOperationalProvider: _FakeCampaignProvider(pack: pack),
    requestedMode: ManasikunaIntegrationMode.campaignConnected,
  );
}

Manasikuna1448Runtime _nusukRuntime({
  required _FakeNusukProvider nusuk,
}) {
  return Manasikuna1448Runtime(
    standaloneProfileProvider: _FakeProfileProvider(
      providerId: 'local.synthetic',
      profile: _approvedSeed('LOCAL-001'),
    ),
    campaignProfileProvider: _FakeProfileProvider(
      providerId: 'official-seed.synthetic',
      profile: _approvedSeed('OFFICIAL-001'),
    ),
    campaignOperationalProvider: _FakeCampaignProvider(pack: _campaignPack()),
    nusukProvider: nusuk,
    requestedMode: ManasikunaIntegrationMode.nusukConnected,
  );
}

OfficialPilgrimSeed _approvedSeed(String reference) {
  return OfficialPilgrimSeed(
    officialReference: reference,
    fullNameAr: 'حاج تجريبي',
    acceptanceStatus: OfficialPilgrimAcceptanceStatus.approved,
    sourceAuthority: 'authorized-source.synthetic',
    sourceRevision: 'rev-synthetic-1',
    effectiveAt: DateTime.utc(2026, 9, 2, 12),
    campaignReference: 'campaign-synthetic-1',
    groupReference: 'group-synthetic-1',
  );
}

CampaignOperationalPack _campaignPack({
  String campaignReference = 'campaign-synthetic-1',
  String packId = 'pack-synthetic-001',
  String? groupReference = 'group-synthetic-1',
}) {
  return CampaignOperationalPack(
    packId: packId,
    schemaVersion: 1,
    campaignReference: campaignReference,
    campaignNameAr: 'حملة تجريبية',
    updatedAt: DateTime.utc(2026, 9, 2, 12),
    groupReference: groupReference,
    supervisor: const OperationalContact(
      roleAr: 'مشرف تجريبي',
      nameAr: 'مشرف افتراضي',
      phone: '+0000000000',
    ),
    meetingPoints: const <CampaignMeetingPoint>[
      CampaignMeetingPoint(
        id: 'meeting-1',
        labelAr: 'نقطة تجمع تجريبية',
        descriptionAr: 'بيانات اصطناعية للاختبار فقط',
      ),
    ],
  );
}

class _FakeProfileProvider implements PilgrimProfileProvider {
  _FakeProfileProvider({
    required this.providerId,
    required this.profile,
    this.error,
  });

  @override
  final String providerId;
  final OfficialPilgrimSeed? profile;
  final Object? error;
  int calls = 0;

  @override
  Future<OfficialPilgrimSeed?> loadProfile({
    ActivationCredential? activation,
  }) async {
    calls += 1;
    if (error != null) {
      throw error!;
    }
    return profile;
  }
}

class _FakeCampaignProvider implements CampaignOperationalProvider {
  _FakeCampaignProvider({
    required this.pack,
    this.error,
  });

  final CampaignOperationalPack? pack;
  final Object? error;
  int calls = 0;

  @override
  String get providerId => 'campaign-pack.synthetic';

  @override
  Future<CampaignOperationalPack?> loadCampaignPack({
    required OfficialPilgrimSeed pilgrim,
    ActivationCredential? activation,
  }) async {
    calls += 1;
    if (error != null) {
      throw error!;
    }
    return pack;
  }
}

class _FakeNusukProvider implements NusukCompatibilityProvider {
  _FakeNusukProvider({
    required this.available,
    required this.profile,
    required this.pack,
    this.profileError,
    this.packError,
  });

  final bool available;
  final OfficialPilgrimSeed? profile;
  final CampaignOperationalPack? pack;
  final Object? profileError;
  final Object? packError;
  int profileCalls = 0;
  int packCalls = 0;

  @override
  bool get isOfficiallyAvailable => available;

  @override
  String get providerId => 'nusuk.synthetic';

  @override
  Future<OfficialPilgrimSeed?> loadProfile({
    ActivationCredential? activation,
  }) async {
    profileCalls += 1;
    if (profileError != null) {
      throw profileError!;
    }
    return profile;
  }

  @override
  Future<CampaignOperationalPack?> loadCampaignPack({
    required OfficialPilgrimSeed pilgrim,
    ActivationCredential? activation,
  }) async {
    packCalls += 1;
    if (packError != null) {
      throw packError!;
    }
    return pack;
  }
}
