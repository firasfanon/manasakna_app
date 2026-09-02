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
