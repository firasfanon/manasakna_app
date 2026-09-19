enum JourneyType { hajj, umrah }

enum AuthorityKind {
  government,
  delegatedCompany,
  commercialCompany,
  commonTraveler,
  externalProvider
}

enum JourneyFreshness { fresh, stale, offlineSnapshot, unknown }

class AuthorityProvenance {
  const AuthorityProvenance({
    required this.sourceAuthority,
    required this.sourceId,
    required this.observedAt,
    this.isAuthoritative = false,
  });

  final AuthorityKind sourceAuthority;
  final String sourceId;
  final DateTime observedAt;
  final bool isAuthoritative;

  Map<String, Object?> toJson() => {
        'source_authority': sourceAuthority.name,
        'source_id': sourceId,
        'observed_at': observedAt.toUtc().toIso8601String(),
        'is_authoritative': isAuthoritative,
      };

  static AuthorityProvenance fromJson(Map<String, Object?> json) {
    final sourceId = json['source_id'];
    final observedAt = json['observed_at'];
    final sourceAuthority = _enumByName(
      AuthorityKind.values,
      json['source_authority'],
      'INVALID_SOURCE_AUTHORITY',
    );
    if (sourceId is! String || sourceId.trim().isEmpty) {
      throw const FormatException('INVALID_SOURCE_ID');
    }
    if (observedAt is! String) {
      throw const FormatException('INVALID_OBSERVED_AT');
    }
    final parsedAt = DateTime.tryParse(observedAt);
    if (parsedAt == null) {
      throw const FormatException('INVALID_OBSERVED_AT');
    }
    return AuthorityProvenance(
      sourceAuthority: sourceAuthority,
      sourceId: sourceId,
      observedAt: parsedAt,
      isAuthoritative: json['is_authoritative'] == true,
    );
  }
}

class JourneySection<T> {
  const JourneySection({required this.value, required this.provenance});
  final T? value;
  final AuthorityProvenance provenance;
}

class JourneyContext {
  const JourneyContext({
    required this.schemaVersion,
    required this.journeyId,
    required this.journeyType,
    required this.travelerContext,
    required this.sourceAuthority,
    required this.authorityProvenance,
    required this.organizationContext,
    required this.group,
    required this.supervisor,
    required this.accommodation,
    required this.room,
    required this.transport,
    required this.flights,
    required this.schedule,
    required this.meetingPoints,
    required this.documents,
    required this.notifications,
    required this.support,
    required this.guidance,
    required this.featureEntitlements,
    required this.freshness,
    required this.snapshotAt,
  });

  static const currentSchemaVersion = '1.0';

  final String schemaVersion;
  final String journeyId;
  final JourneyType journeyType;
  final Map<String, Object?> travelerContext;
  final AuthorityKind sourceAuthority;
  final AuthorityProvenance authorityProvenance;
  final JourneySection<Map<String, Object?>> organizationContext;
  final JourneySection<Map<String, Object?>> group;
  final JourneySection<Map<String, Object?>> supervisor;
  final JourneySection<Map<String, Object?>> accommodation;
  final JourneySection<Map<String, Object?>> room;
  final JourneySection<List<Map<String, Object?>>> transport;
  final JourneySection<List<Map<String, Object?>>> flights;
  final JourneySection<List<Map<String, Object?>>> schedule;
  final JourneySection<List<Map<String, Object?>>> meetingPoints;
  final JourneySection<List<Map<String, Object?>>> documents;
  final JourneySection<List<Map<String, Object?>>> notifications;
  final JourneySection<Map<String, Object?>> support;
  final JourneySection<List<Map<String, Object?>>> guidance;
  final Set<String> featureEntitlements;
  final JourneyFreshness freshness;
  final DateTime snapshotAt;

  void validate() {
    if (schemaVersion != currentSchemaVersion) {
      throw const FormatException('UNSUPPORTED_JOURNEY_CONTEXT_VERSION');
    }
    if (journeyId.trim().isEmpty) {
      throw const FormatException('MISSING_JOURNEY_ID');
    }
    if (authorityProvenance.sourceAuthority != sourceAuthority) {
      throw const FormatException('AUTHORITY_PROVENANCE_MISMATCH');
    }
    if (sourceAuthority == AuthorityKind.externalProvider &&
        !authorityProvenance.isAuthoritative) {
      throw const FormatException('AMBIGUOUS_EXTERNAL_AUTHORITY');
    }
    if (journeyType == JourneyType.hajj) {
      if (sourceAuthority != AuthorityKind.government ||
          !authorityProvenance.isAuthoritative) {
        throw const FormatException(
          'HAJJ_ROOT_REQUIRES_AUTHORITATIVE_GOVERNMENT',
        );
      }
      _validateHajjGovernmentPlane();
    }
    if (journeyType == JourneyType.umrah &&
        sourceAuthority == AuthorityKind.government &&
        !authorityProvenance.isAuthoritative) {
      throw const FormatException('AMBIGUOUS_UMRAH_GOVERNMENT_AUTHORITY');
    }
    if (freshness == JourneyFreshness.unknown) {
      throw const FormatException('UNKNOWN_FRESHNESS');
    }
  }

  void _validateHajjGovernmentPlane() {
    final sections = <JourneySection<Object?>>[
      organizationContext,
      group,
      supervisor,
      accommodation,
      room,
      transport,
      flights,
      schedule,
      meetingPoints,
      documents,
      notifications,
      support,
      guidance,
    ];
    for (final section in sections) {
      if (section.provenance.sourceAuthority ==
          AuthorityKind.commercialCompany) {
        throw const FormatException(
          'COMMERCIAL_COMPANY_PROHIBITED_IN_HAJJ_PLANE',
        );
      }
      if (section.provenance.sourceAuthority ==
              AuthorityKind.externalProvider &&
          !section.provenance.isAuthoritative) {
        throw const FormatException(
          'AMBIGUOUS_HAJJ_EXTERNAL_SECTION_AUTHORITY',
        );
      }
    }
    for (final section in <JourneySection<Object?>>[
      organizationContext,
      group,
    ]) {
      if (section.provenance.sourceAuthority != AuthorityKind.government &&
          section.provenance.sourceAuthority !=
              AuthorityKind.delegatedCompany) {
        throw const FormatException('INVALID_HAJJ_ORGANIZATION_AUTHORITY');
      }
    }
  }

  Map<String, Object?> toJson() => {
        'schema_version': schemaVersion,
        'journey_id': journeyId,
        'journey_type': journeyType.name,
        'traveler_context': travelerContext,
        'source_authority': sourceAuthority.name,
        'authority_provenance': authorityProvenance.toJson(),
        'feature_entitlements': featureEntitlements.toList()..sort(),
        'freshness': freshness.name,
        'snapshot_at': snapshotAt.toUtc().toIso8601String(),
      };

  static JourneyContext fromEnvelope(
    Map<String, Object?> json, {
    required JourneyContext Function({
      required String schemaVersion,
      required String journeyId,
      required JourneyType journeyType,
      required Map<String, Object?> travelerContext,
      required AuthorityKind sourceAuthority,
      required AuthorityProvenance authorityProvenance,
      required Set<String> featureEntitlements,
      required JourneyFreshness freshness,
      required DateTime snapshotAt,
    }) buildSections,
  }) {
    final schemaVersion = json['schema_version'];
    final journeyId = json['journey_id'];
    final traveler = json['traveler_context'];
    final provenance = json['authority_provenance'];
    final snapshot = json['snapshot_at'];
    final entitlements = json['feature_entitlements'];
    if (schemaVersion is! String ||
        journeyId is! String ||
        traveler is! Map ||
        provenance is! Map ||
        snapshot is! String ||
        entitlements is! List) {
      throw const FormatException('CORRUPT_JOURNEY_CONTEXT_ENVELOPE');
    }
    final snapshotAt = DateTime.tryParse(snapshot);
    if (snapshotAt == null) {
      throw const FormatException('INVALID_SNAPSHOT_AT');
    }
    final context = buildSections(
      schemaVersion: schemaVersion,
      journeyId: journeyId,
      journeyType: _enumByName(
        JourneyType.values,
        json['journey_type'],
        'INVALID_JOURNEY_TYPE',
      ),
      travelerContext: Map<String, Object?>.from(traveler),
      sourceAuthority: _enumByName(
        AuthorityKind.values,
        json['source_authority'],
        'INVALID_SOURCE_AUTHORITY',
      ),
      authorityProvenance: AuthorityProvenance.fromJson(
        Map<String, Object?>.from(provenance),
      ),
      featureEntitlements: entitlements.whereType<String>().toSet(),
      freshness: _enumByName(
        JourneyFreshness.values,
        json['freshness'],
        'INVALID_FRESHNESS',
      ),
      snapshotAt: snapshotAt,
    );
    context.validate();
    return context;
  }
}

T _enumByName<T extends Enum>(
  List<T> values,
  Object? raw,
  String error,
) {
  if (raw is! String) throw FormatException(error);
  for (final value in values) {
    if (value.name == raw) return value;
  }
  throw FormatException(error);
}
