import '../domain/journey_context.dart';
import '../domain/journey_context_provider.dart';

abstract interface class HajjGovernmentSource {
  String get sourceId;
  Future<JourneyContext> loadGovernmentJourney();
}

abstract interface class HajjDelegatedOperationsSource {
  String get sourceId;
  Future<HajjDelegatedOperations> loadOperations(String journeyId);
}

class HajjDelegatedOperations {
  const HajjDelegatedOperations(
      {required this.sourceId,
      required this.observedAt,
      this.supervisor,
      this.accommodation,
      this.room,
      this.transport,
      this.schedule,
      this.meetingPoints});
  final String sourceId;
  final DateTime observedAt;
  final Map<String, Object?>? supervisor;
  final Map<String, Object?>? accommodation;
  final Map<String, Object?>? room;
  final List<Map<String, Object?>>? transport;
  final List<Map<String, Object?>>? schedule;
  final List<Map<String, Object?>>? meetingPoints;
  AuthorityProvenance get provenance => AuthorityProvenance(
      sourceAuthority: AuthorityKind.delegatedCompany,
      sourceId: sourceId,
      observedAt: observedAt,
      isAuthoritative: false);
}

class HajjGovernmentPlaneProvider implements JourneyContextProvider {
  const HajjGovernmentPlaneProvider(
      {required this.government, this.delegatedOperations});
  final HajjGovernmentSource government;
  final HajjDelegatedOperationsSource? delegatedOperations;
  @override
  String get providerId => 'hajj-government-plane-v1:${government.sourceId}';
  @override
  Future<JourneyContext> loadJourneyContext() async {
    final root = await government.loadGovernmentJourney();
    root.validate();
    if (root.journeyType != JourneyType.hajj ||
        root.sourceAuthority != AuthorityKind.government ||
        !root.authorityProvenance.isAuthoritative) {
      throw const FormatException('INVALID_HAJJ_GOVERNMENT_ROOT');
    }
    final delegated = delegatedOperations == null
        ? null
        : await delegatedOperations!.loadOperations(root.journeyId);
    if (delegated == null) return root;
    final p = delegated.provenance;
    final context = JourneyContext(
      schemaVersion: root.schemaVersion,
      journeyId: root.journeyId,
      journeyType: root.journeyType,
      travelerContext: root.travelerContext,
      sourceAuthority: root.sourceAuthority,
      authorityProvenance: root.authorityProvenance,
      organizationContext: root.organizationContext,
      group: root.group,
      supervisor: delegated.supervisor == null
          ? root.supervisor
          : JourneySection(value: delegated.supervisor, provenance: p),
      accommodation: delegated.accommodation == null
          ? root.accommodation
          : JourneySection(value: delegated.accommodation, provenance: p),
      room: delegated.room == null
          ? root.room
          : JourneySection(value: delegated.room, provenance: p),
      transport: delegated.transport == null
          ? root.transport
          : JourneySection(value: delegated.transport, provenance: p),
      flights: root.flights,
      schedule: delegated.schedule == null
          ? root.schedule
          : JourneySection(value: delegated.schedule, provenance: p),
      meetingPoints: delegated.meetingPoints == null
          ? root.meetingPoints
          : JourneySection(value: delegated.meetingPoints, provenance: p),
      documents: root.documents,
      notifications: root.notifications,
      support: root.support,
      guidance: root.guidance,
      featureEntitlements: root.featureEntitlements,
      freshness: root.freshness,
      snapshotAt: root.snapshotAt,
    );
    context.validate();
    return context;
  }
}
