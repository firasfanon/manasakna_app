enum ManasikunaIntegrationMode {
  standalone,
  campaignConnected,
  nusukConnected,
}

extension ManasikunaIntegrationModeX on ManasikunaIntegrationMode {
  bool get requiresNusuk => this == ManasikunaIntegrationMode.nusukConnected;

  bool get isStandalone => this == ManasikunaIntegrationMode.standalone;

  String get labelAr {
    switch (this) {
      case ManasikunaIntegrationMode.standalone:
        return 'مستقل';
      case ManasikunaIntegrationMode.campaignConnected:
        return 'مرتبط بالحملة';
      case ManasikunaIntegrationMode.nusukConnected:
        return 'مرتبط بنسك';
    }
  }
}

enum OfficialPilgrimAcceptanceStatus {
  approved,
  waitlisted,
  withdrawn,
  cancelled,
  replaced,
}

extension OfficialPilgrimAcceptanceStatusX on OfficialPilgrimAcceptanceStatus {
  bool get canActivateManasikuna =>
      this == OfficialPilgrimAcceptanceStatus.approved;
}

enum Manasikuna1448ContractDataClass {
  legacyUnverified,
  syntheticFixture,
  approvedNonPersonalFixture,
  realPersonalData,
}

enum Manasikuna1448ContractApprovalState {
  unverified,
  approvedForFixtureUse,
  approvedForRealUse,
  revoked,
}

class Manasikuna1448ContractMetadata {
  const Manasikuna1448ContractMetadata({
    required this.contractVersion,
    required this.authorityModel,
    required this.sourceAuthority,
    required this.sourceRevision,
    required this.provenanceReference,
    required this.dataClass,
    required this.approvalState,
    required this.issuedAt,
    this.expiresAt,
    this.revoked = false,
    this.updateSequence = 1,
    this.integrityAlgorithm,
    this.integrityDigest,
    this.signatureReference,
  });

  final String contractVersion;

  /// Governing authority model, not an assertion that a fixture is real data.
  final String authorityModel;
  final String sourceAuthority;
  final String sourceRevision;
  final String provenanceReference;
  final Manasikuna1448ContractDataClass dataClass;
  final Manasikuna1448ContractApprovalState approvalState;
  final DateTime issuedAt;
  final DateTime? expiresAt;
  final bool revoked;
  final int updateSequence;

  /// Evidence references supplied by the producing adapter.
  ///
  /// Wave C validates presence/shape for synthetic fixtures. Cryptographic
  /// verification of a future real transport remains a separate endpoint gate.
  final String? integrityAlgorithm;
  final String? integrityDigest;
  final String? signatureReference;

  bool isTemporallyValidAt(DateTime moment) {
    final utc = moment.toUtc();
    if (utc.isBefore(issuedAt.toUtc())) {
      return false;
    }

    final expiry = expiresAt;
    return expiry == null || utc.isBefore(expiry.toUtc());
  }
}

class OfficialPilgrimSeed {
  const OfficialPilgrimSeed({
    required this.officialReference,
    required this.fullNameAr,
    required this.acceptanceStatus,
    required this.sourceAuthority,
    required this.sourceRevision,
    required this.effectiveAt,
    this.campaignReference,
    this.groupReference,
    this.contractMetadata,
  });

  /// An application or authority-issued reference. It must not be assumed to be
  /// a national ID and must not be displayed as one.
  final String officialReference;
  final String fullNameAr;
  final OfficialPilgrimAcceptanceStatus acceptanceStatus;
  final String sourceAuthority;
  final String sourceRevision;
  final DateTime effectiveAt;
  final String? campaignReference;
  final String? groupReference;

  /// Null means legacy/unverified contract state. Wave C governed runtime
  /// rejects null metadata for any connected campaign path.
  final Manasikuna1448ContractMetadata? contractMetadata;

  bool get isActivationEligible => acceptanceStatus.canActivateManasikuna;
}

class CampaignMeetingPoint {
  const CampaignMeetingPoint({
    required this.id,
    required this.labelAr,
    required this.descriptionAr,
    this.latitude,
    this.longitude,
  });

  final String id;
  final String labelAr;
  final String descriptionAr;
  final double? latitude;
  final double? longitude;
}

class CampaignScheduleItem {
  const CampaignScheduleItem({
    required this.id,
    required this.titleAr,
    required this.startsAt,
    this.endsAt,
    this.meetingPointId,
    this.notesAr,
  });

  final String id;
  final String titleAr;
  final DateTime startsAt;
  final DateTime? endsAt;
  final String? meetingPointId;
  final String? notesAr;
}

class OperationalContact {
  const OperationalContact({
    required this.roleAr,
    required this.nameAr,
    required this.phone,
  });

  final String roleAr;
  final String nameAr;
  final String phone;
}

class CampaignOperationalPack {
  const CampaignOperationalPack({
    required this.packId,
    required this.schemaVersion,
    required this.campaignReference,
    required this.campaignNameAr,
    required this.updatedAt,
    this.groupReference,
    this.supervisor,
    this.hotelNameAr,
    this.hotelAddressAr,
    this.transportLabelAr,
    this.minaCampAr,
    this.arafatCampAr,
    this.meetingPoints = const <CampaignMeetingPoint>[],
    this.schedule = const <CampaignScheduleItem>[],
    this.emergencyContacts = const <OperationalContact>[],
    this.contractMetadata,
  });

  final String packId;
  final int schemaVersion;
  final String campaignReference;
  final String campaignNameAr;
  final DateTime updatedAt;
  final String? groupReference;
  final OperationalContact? supervisor;
  final String? hotelNameAr;
  final String? hotelAddressAr;
  final String? transportLabelAr;
  final String? minaCampAr;
  final String? arafatCampAr;
  final List<CampaignMeetingPoint> meetingPoints;
  final List<CampaignScheduleItem> schedule;
  final List<OperationalContact> emergencyContacts;

  /// Null means legacy/unverified contract state. Wave C governed runtime
  /// rejects null metadata for any connected campaign path.
  final Manasikuna1448ContractMetadata? contractMetadata;
}

class ActivationCredential {
  ActivationCredential({
    required this.opaqueToken,
    required this.issuedAt,
    required this.expiresAt,
    this.packId,
  }) {
    if (opaqueToken.trim().isEmpty) {
      throw ArgumentError.value(
        opaqueToken,
        'opaqueToken',
        'Activation token must not be blank.',
      );
    }
    if (!expiresAt.isAfter(issuedAt)) {
      throw ArgumentError(
        'Activation expiry must be strictly after its issue time.',
      );
    }
    if (packId != null && packId!.trim().isEmpty) {
      throw ArgumentError.value(
        packId,
        'packId',
        'Activation packId must not be blank when provided.',
      );
    }
  }

  /// Opaque token only. Personal data must never be embedded in this value.
  final String opaqueToken;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final String? packId;

  bool isValidAt(DateTime moment) {
    return !moment.isBefore(issuedAt) && moment.isBefore(expiresAt);
  }
}
