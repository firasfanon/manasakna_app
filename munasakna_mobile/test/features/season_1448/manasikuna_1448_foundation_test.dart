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

      expect(result.resolution.effectiveMode,
          ManasikunaIntegrationMode.standalone);
      expect(result.profile?.officialReference, 'LOCAL-001');
      expect(result.campaignPack, isNull);
      expect(nusuk.profileCalls, 0);
      expect(nusuk.packCalls, 0);
    });

    test('campaign mode uses authorized seed provider plus operational pack',
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

      expect(result.resolution.effectiveMode,
          ManasikunaIntegrationMode.standalone);
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

      expect(result.resolution.effectiveMode,
          ManasikunaIntegrationMode.standalone);
      expect(campaignPack.calls, 0);
    });
  });
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

CampaignOperationalPack _campaignPack() {
  return CampaignOperationalPack(
    packId: 'pack-synthetic-001',
    schemaVersion: 1,
    campaignReference: 'campaign-synthetic-1',
    campaignNameAr: 'حملة تجريبية',
    updatedAt: DateTime.utc(2026, 9, 2, 12),
    groupReference: 'group-synthetic-1',
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
  });

  @override
  final String providerId;
  final OfficialPilgrimSeed? profile;
  int calls = 0;

  @override
  Future<OfficialPilgrimSeed?> loadProfile({
    ActivationCredential? activation,
  }) async {
    calls += 1;
    return profile;
  }
}

class _FakeCampaignProvider implements CampaignOperationalProvider {
  _FakeCampaignProvider({required this.pack});

  final CampaignOperationalPack? pack;
  int calls = 0;

  @override
  String get providerId => 'campaign-pack.synthetic';

  @override
  Future<CampaignOperationalPack?> loadCampaignPack({
    required OfficialPilgrimSeed pilgrim,
    ActivationCredential? activation,
  }) async {
    calls += 1;
    return pack;
  }
}

class _FakeNusukProvider implements NusukCompatibilityProvider {
  _FakeNusukProvider({
    required this.available,
    required this.profile,
    required this.pack,
  });

  final bool available;
  final OfficialPilgrimSeed? profile;
  final CampaignOperationalPack? pack;
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
    return profile;
  }

  @override
  Future<CampaignOperationalPack?> loadCampaignPack({
    required OfficialPilgrimSeed pilgrim,
    ActivationCredential? activation,
  }) async {
    packCalls += 1;
    return pack;
  }
}
