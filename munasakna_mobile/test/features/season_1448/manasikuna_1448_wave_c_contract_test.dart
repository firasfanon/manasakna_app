import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/features/season_1448/data/manasikuna_1448_local_store.dart';
import 'package:munasakna_mobile/features/season_1448/data/manasikuna_1448_synthetic_source.dart';
import 'package:munasakna_mobile/features/season_1448/domain/manasikuna_1448_contract_policy.dart';
import 'package:munasakna_mobile/features/season_1448/domain/manasikuna_1448_launch_models.dart';
import 'package:munasakna_mobile/features/season_1448/domain/manasikuna_1448_models.dart';
import 'package:munasakna_mobile/features/season_1448/domain/manasikuna_1448_provider_contracts.dart';
import 'package:munasakna_mobile/features/season_1448/domain/manasikuna_1448_runtime.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const policy = Manasikuna1448WaveCContractPolicy.syntheticFixturesOnly();
  final now = DateTime.utc(2026, 9, 5, 12);

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('synthetic fixture carries complete governed Wave C contracts',
      () async {
    final bundle = const Manasikuna1448SyntheticSource().bundleForToken(
      Manasikuna1448SyntheticSource.demoToken,
      now: now,
    )!;

    final profile = await bundle.profileProvider.loadProfile(
      activation: bundle.credential,
    );
    expect(profile, isNotNull);

    final pack = await bundle.operationalProvider.loadCampaignPack(
      pilgrim: profile!,
      activation: bundle.credential,
    );
    expect(pack, isNotNull);

    expect(policy.profileViolation(profile, now), isNull);
    expect(
      policy.campaignPackViolation(
        profile: profile,
        pack: pack!,
        moment: now,
      ),
      isNull,
    );
    expect(
      policy.activationViolation(
        activation: bundle.credential,
        profile: profile,
        pack: pack,
      ),
      isNull,
    );

    expect(
      profile.contractMetadata?.dataClass,
      Manasikuna1448ContractDataClass.syntheticFixture,
    );
    expect(
      pack.contractMetadata?.approvalState,
      Manasikuna1448ContractApprovalState.approvedForFixtureUse,
    );
    expect(
      pack.contractMetadata?.authorityModel,
      Manasikuna1448WaveCContractPolicy.authorityModel,
    );
    expect(pack.contractMetadata?.integrityDigest, hasLength(64));
    expect(pack.contractMetadata?.signatureReference, isNotEmpty);
  });

  test('real personal data classification is rejected fail-closed', () {
    final profile = _profile(
      metadata: _metadata(
        version: Manasikuna1448WaveCContractPolicy.pilgrimSeedContractVersion,
        dataClass: Manasikuna1448ContractDataClass.realPersonalData,
      ),
    );

    expect(
      policy.profileViolation(profile, now),
      'non_synthetic_data_rejected',
    );
  });

  test('revoked campaign pack is rejected fail-closed', () {
    final profile = _profile();
    final pack = _pack(
      metadata: _metadata(
        version: Manasikuna1448WaveCContractPolicy.campaignPackContractVersion,
        revoked: true,
        integrity: true,
      ),
    );

    expect(
      policy.campaignPackViolation(
        profile: profile,
        pack: pack,
        moment: now,
      ),
      'revoked',
    );
  });

  test('expired campaign contract is rejected fail-closed', () {
    final profile = _profile();
    final pack = _pack(
      metadata: _metadata(
        version: Manasikuna1448WaveCContractPolicy.campaignPackContractVersion,
        expiresAt: now.subtract(const Duration(seconds: 1)),
        integrity: true,
      ),
    );

    expect(
      policy.campaignPackViolation(
        profile: profile,
        pack: pack,
        moment: now,
      ),
      'expired_or_not_yet_valid',
    );
  });

  test(
      'operational freshness may predate contract issuance without invalidating the contract',
      () {
    final profile = _profile();
    final pack = _pack(
      updatedAt: now.subtract(const Duration(hours: 25)),
    );

    expect(
      policy.campaignPackViolation(
        profile: profile,
        pack: pack,
        moment: now,
      ),
      isNull,
    );
    expect(
      now.difference(pack.updatedAt.toUtc()),
      greaterThan(const Duration(hours: 24)),
    );
  });

  test('activation token containing direct identity is rejected', () {
    final profile = _profile();
    final pack = _pack();
    final activation = ActivationCredential(
      opaqueToken: 'opaque-${profile.officialReference}-token',
      issuedAt: now.subtract(const Duration(minutes: 1)),
      expiresAt: now.add(const Duration(hours: 1)),
      packId: pack.packId,
    );

    expect(
      policy.activationViolation(
        activation: activation,
        profile: profile,
        pack: pack,
      ),
      'opaque_token_contains_direct_identity_or_context',
    );
  });

  test('governed runtime rejects legacy unverified connected profile',
      () async {
    final runtime = Manasikuna1448Runtime(
      standaloneProfileProvider:
          const Manasikuna1448NullStandaloneProfileProvider(),
      campaignProfileProvider: _StaticProfileProvider(
        _profile(metadata: null, useDefaultMetadata: false),
      ),
      campaignOperationalProvider: _StaticPackProvider(_pack()),
      requestedMode: ManasikunaIntegrationMode.campaignConnected,
      waveCContractPolicy: policy,
    );

    final result = await runtime.resolve(
      activation: _activation(),
      now: now,
    );

    expect(
      result.resolution.effectiveMode,
      ManasikunaIntegrationMode.standalone,
    );
    expect(
      result.resolution.fallbackReasonCode,
      'campaign_profile_contract_metadata_missing',
    );
  });

  test('connected provider timeout is classified and degrades safely',
      () async {
    final runtime = Manasikuna1448Runtime(
      standaloneProfileProvider:
          const Manasikuna1448NullStandaloneProfileProvider(),
      campaignProfileProvider: _NeverProfileProvider(),
      campaignOperationalProvider: _StaticPackProvider(_pack()),
      requestedMode: ManasikunaIntegrationMode.campaignConnected,
      waveCContractPolicy: policy,
      connectedProviderTimeout: const Duration(milliseconds: 10),
    );

    final result = await runtime.resolve(
      activation: _activation(),
      now: now,
    );

    expect(
      result.resolution.effectiveMode,
      ManasikunaIntegrationMode.standalone,
    );
    expect(
      result.resolution.fallbackReasonCode,
      'campaign_profile_provider_timeout',
    );
    expect(result.resolution.isDegraded, isTrue);
  });

  test('runtime rejects non-positive connected provider timeout', () {
    expect(
      () => Manasikuna1448Runtime(
        standaloneProfileProvider:
            const Manasikuna1448NullStandaloneProfileProvider(),
        connectedProviderTimeout: Duration.zero,
      ),
      throwsArgumentError,
    );
  });

  test('snapshot v2 persists contract metadata but never raw activation token',
      () async {
    const source = Manasikuna1448SyntheticSource();
    final bundle = source.bundleForToken(
      Manasikuna1448SyntheticSource.demoToken,
      now: now,
    )!;
    final runtime = Manasikuna1448Runtime(
      standaloneProfileProvider:
          const Manasikuna1448NullStandaloneProfileProvider(),
      campaignProfileProvider: bundle.profileProvider,
      campaignOperationalProvider: bundle.operationalProvider,
      requestedMode: ManasikunaIntegrationMode.campaignConnected,
      waveCContractPolicy: policy,
    );
    final resolved = await runtime.resolve(
      activation: bundle.credential,
      now: now,
    );

    const store = Manasikuna1448LocalStore();
    await store.save(
      Manasikuna1448LaunchSession(
        profile: resolved.profile!,
        pack: resolved.campaignPack!,
        activatedAtUtc: now,
        credentialExpiresAtUtc: bundle.credential.expiresAt,
        savedAtUtc: now,
      ),
    );

    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(Manasikuna1448LocalStore.snapshotKey);
    expect(raw, isNotNull);
    expect(raw, isNot(contains(Manasikuna1448SyntheticSource.demoToken)));

    final decoded = Map<String, dynamic>.from(jsonDecode(raw!) as Map);
    expect(
      decoded['schemaVersion'],
      Manasikuna1448LocalStore.snapshotSchemaVersion,
    );
    expect(Manasikuna1448LocalStore.snapshotSchemaVersion, 2);

    final profileJson = Map<String, dynamic>.from(decoded['profile'] as Map);
    final packJson = Map<String, dynamic>.from(decoded['pack'] as Map);
    expect(profileJson['contractMetadata'], isA<Map>());
    expect(packJson['contractMetadata'], isA<Map>());

    final restored = await store.restore();
    expect(restored, isNotNull);
    expect(
      restored!.pack.contractMetadata?.contractVersion,
      Manasikuna1448WaveCContractPolicy.campaignPackContractVersion,
    );
  });

  test('legacy snapshot schema v1 is invalidated instead of silently migrated',
      () async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      Manasikuna1448LocalStore.snapshotKey,
      jsonEncode(<String, Object>{'schemaVersion': 1}),
    );

    const store = Manasikuna1448LocalStore();
    expect(await store.restore(), isNull);
    expect(
      preferences.containsKey(Manasikuna1448LocalStore.snapshotKey),
      isFalse,
    );
  });
}

ActivationCredential _activation() {
  return ActivationCredential(
    opaqueToken: 'M1448-OPAQUE-TEST-001',
    issuedAt: DateTime.utc(2026, 9, 5, 11),
    expiresAt: DateTime.utc(2026, 9, 6, 12),
    packId: 'pack-synthetic-test',
  );
}

OfficialPilgrimSeed _profile({
  Manasikuna1448ContractMetadata? metadata,
  bool useDefaultMetadata = true,
}) {
  final resolvedMetadata = useDefaultMetadata
      ? (metadata ??
          _metadata(
            version:
                Manasikuna1448WaveCContractPolicy.pilgrimSeedContractVersion,
          ))
      : metadata;

  return OfficialPilgrimSeed(
    officialReference: 'SYNTH-OFFICIAL-001',
    fullNameAr: 'حاج تجريبي',
    acceptanceStatus: OfficialPilgrimAcceptanceStatus.approved,
    sourceAuthority: resolvedMetadata?.sourceAuthority ?? 'legacy-unverified',
    sourceRevision: resolvedMetadata?.sourceRevision ?? 'legacy-unverified',
    effectiveAt: DateTime.utc(2026, 9, 5, 12),
    campaignReference: 'campaign-synthetic-test',
    groupReference: 'group-synthetic-test',
    contractMetadata: resolvedMetadata,
  );
}

CampaignOperationalPack _pack({
  Manasikuna1448ContractMetadata? metadata,
  DateTime? updatedAt,
}) {
  return CampaignOperationalPack(
    packId: 'pack-synthetic-test',
    schemaVersion: 1,
    campaignReference: 'campaign-synthetic-test',
    campaignNameAr: 'حملة تجريبية',
    updatedAt: updatedAt ?? DateTime.utc(2026, 9, 5, 12),
    groupReference: 'group-synthetic-test',
    contractMetadata: metadata ??
        _metadata(
          version:
              Manasikuna1448WaveCContractPolicy.campaignPackContractVersion,
          integrity: true,
        ),
  );
}

Manasikuna1448ContractMetadata _metadata({
  required String version,
  Manasikuna1448ContractDataClass dataClass =
      Manasikuna1448ContractDataClass.syntheticFixture,
  bool revoked = false,
  bool integrity = false,
  DateTime? expiresAt,
}) {
  return Manasikuna1448ContractMetadata(
    contractVersion: version,
    authorityModel: Manasikuna1448WaveCContractPolicy.authorityModel,
    sourceAuthority: 'official-hajj-system.synthetic-fixture',
    sourceRevision: 'synthetic-test-r1',
    provenanceReference: 'synthetic://test/provenance',
    dataClass: dataClass,
    approvalState: Manasikuna1448ContractApprovalState.approvedForFixtureUse,
    issuedAt: DateTime.utc(2026, 9, 5, 11),
    expiresAt: expiresAt ?? DateTime.utc(2026, 12, 1),
    revoked: revoked,
    updateSequence: 1,
    integrityAlgorithm: integrity ? 'SHA-256' : null,
    integrityDigest: integrity
        ? 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
        : null,
    signatureReference: integrity ? 'synthetic://signature/test' : null,
  );
}

class _StaticProfileProvider implements PilgrimProfileProvider {
  _StaticProfileProvider(this.profile);

  final OfficialPilgrimSeed? profile;

  @override
  String get providerId => 'test.profile';

  @override
  Future<OfficialPilgrimSeed?> loadProfile({
    ActivationCredential? activation,
  }) async {
    return profile;
  }
}

class _StaticPackProvider implements CampaignOperationalProvider {
  _StaticPackProvider(this.pack);

  final CampaignOperationalPack? pack;

  @override
  String get providerId => 'test.pack';

  @override
  Future<CampaignOperationalPack?> loadCampaignPack({
    required OfficialPilgrimSeed pilgrim,
    ActivationCredential? activation,
  }) async {
    return pack;
  }
}

class _NeverProfileProvider implements PilgrimProfileProvider {
  @override
  String get providerId => 'test.profile.never';

  @override
  Future<OfficialPilgrimSeed?> loadProfile({
    ActivationCredential? activation,
  }) {
    return Completer<OfficialPilgrimSeed?>().future;
  }
}
