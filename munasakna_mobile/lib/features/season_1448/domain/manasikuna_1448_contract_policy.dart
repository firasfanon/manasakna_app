import 'manasikuna_1448_models.dart';

/// Wave C fail-closed policy for the authorized synthetic-fixture contract
/// closure. It deliberately does not authorize any real endpoint or real data.
class Manasikuna1448WaveCContractPolicy {
  const Manasikuna1448WaveCContractPolicy.syntheticFixturesOnly();

  static const String authorityModel = 'OFFICIAL_HAJJ_SYSTEM';
  static const String pilgrimSeedContractVersion = 'official-pilgrim-seed.v1';
  static const String campaignPackContractVersion =
      'campaign-operational-pack.v1';

  String? profileViolation(
    OfficialPilgrimSeed profile,
    DateTime moment,
  ) {
    final metadata = profile.contractMetadata;
    if (metadata == null) {
      return 'metadata_missing';
    }

    final common = _commonMetadataViolation(
      metadata,
      expectedVersion: pilgrimSeedContractVersion,
      moment: moment,
      requireIntegrityEvidence: false,
    );
    if (common != null) {
      return common;
    }

    if (profile.sourceAuthority.trim() != metadata.sourceAuthority.trim() ||
        profile.sourceRevision.trim() != metadata.sourceRevision.trim()) {
      return 'provenance_mismatch';
    }

    if (_blank(profile.campaignReference) || _blank(profile.groupReference)) {
      return 'operational_context_missing';
    }

    return null;
  }

  String? campaignPackViolation({
    required OfficialPilgrimSeed profile,
    required CampaignOperationalPack pack,
    required DateTime moment,
  }) {
    final metadata = pack.contractMetadata;
    if (metadata == null) {
      return 'metadata_missing';
    }

    final common = _commonMetadataViolation(
      metadata,
      expectedVersion: campaignPackContractVersion,
      moment: moment,
      requireIntegrityEvidence: true,
    );
    if (common != null) {
      return common;
    }

    if (pack.schemaVersion != 1) {
      return 'schema_version_unsupported';
    }

    final profileCampaign = profile.campaignReference?.trim();
    if (profileCampaign == null ||
        profileCampaign.isEmpty ||
        pack.campaignReference.trim() != profileCampaign) {
      return 'campaign_context_mismatch';
    }

    final profileGroup = profile.groupReference?.trim();
    final packGroup = pack.groupReference?.trim();
    if (profileGroup == null ||
        profileGroup.isEmpty ||
        packGroup == null ||
        packGroup.isEmpty ||
        packGroup != profileGroup) {
      return 'group_context_mismatch';
    }

    return null;
  }

  String? activationViolation({
    required ActivationCredential activation,
    required OfficialPilgrimSeed profile,
    required CampaignOperationalPack pack,
  }) {
    final activationPackId = activation.packId?.trim();
    if (activationPackId != null &&
        activationPackId.isNotEmpty &&
        activationPackId != pack.packId.trim()) {
      return 'pack_binding_mismatch';
    }

    final token = activation.opaqueToken.trim().toLowerCase();
    if (token.length < 12) {
      return 'opaque_token_too_short';
    }

    final directContextValues = <String?>[
      profile.fullNameAr,
      profile.officialReference,
      profile.campaignReference,
      profile.groupReference,
    ];

    for (final value in directContextValues) {
      final normalized = value?.trim().toLowerCase();
      if (normalized != null &&
          normalized.length >= 4 &&
          token.contains(normalized)) {
        return 'opaque_token_contains_direct_identity_or_context';
      }
    }

    return null;
  }

  String? _commonMetadataViolation(
    Manasikuna1448ContractMetadata metadata, {
    required String expectedVersion,
    required DateTime moment,
    required bool requireIntegrityEvidence,
  }) {
    if (metadata.contractVersion.trim() != expectedVersion) {
      return 'contract_version_unsupported';
    }

    if (metadata.authorityModel.trim() != authorityModel) {
      return 'authority_model_mismatch';
    }

    if (_blank(metadata.sourceAuthority) ||
        _blank(metadata.sourceRevision) ||
        _blank(metadata.provenanceReference)) {
      return 'provenance_incomplete';
    }

    if (metadata.dataClass !=
        Manasikuna1448ContractDataClass.syntheticFixture) {
      return 'non_synthetic_data_rejected';
    }

    if (metadata.approvalState !=
        Manasikuna1448ContractApprovalState.approvedForFixtureUse) {
      return 'approval_state_rejected';
    }

    if (metadata.revoked ||
        metadata.approvalState == Manasikuna1448ContractApprovalState.revoked) {
      return 'revoked';
    }

    if (metadata.updateSequence < 1) {
      return 'update_sequence_invalid';
    }

    if (!metadata.isTemporallyValidAt(moment)) {
      return 'expired_or_not_yet_valid';
    }

    if (requireIntegrityEvidence &&
        (_blank(metadata.integrityAlgorithm) ||
            _blank(metadata.integrityDigest) ||
            _blank(metadata.signatureReference))) {
      return 'integrity_or_signature_evidence_missing';
    }

    return null;
  }

  bool _blank(String? value) => value == null || value.trim().isEmpty;
}
