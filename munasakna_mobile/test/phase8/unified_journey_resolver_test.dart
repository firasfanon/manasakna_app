import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/features/journey_contract/domain/journey_context.dart';
import 'package:munasakna_mobile/features/unified_journey/data/phase8_journey_catalog.dart';
import 'package:munasakna_mobile/features/unified_journey/domain/unified_journey_resolution.dart';

JourneyContext withJourneyId(JourneyContext source, String journeyId) {
  return JourneyContext(
    schemaVersion: source.schemaVersion,
    journeyId: journeyId,
    journeyType: source.journeyType,
    travelerContext: source.travelerContext,
    sourceAuthority: source.sourceAuthority,
    authorityProvenance: source.authorityProvenance,
    organizationContext: source.organizationContext,
    group: source.group,
    supervisor: source.supervisor,
    accommodation: source.accommodation,
    room: source.room,
    transport: source.transport,
    flights: source.flights,
    schedule: source.schedule,
    meetingPoints: source.meetingPoints,
    documents: source.documents,
    notifications: source.notifications,
    support: source.support,
    guidance: source.guidance,
    featureEntitlements: source.featureEntitlements,
    freshness: source.freshness,
    snapshotAt: source.snapshotAt,
  );
}

void main() {
  test('Phase 8 resolves Hajj and Umrah without merging authority', () async {
    final contexts =
        await const LocalPhase8JourneyCatalog().loadEligibleJourneys();

    final resolution = const UnifiedJourneyResolver().resolve(
      contexts,
      preferredType: JourneyType.hajj,
    );

    expect(resolution.candidates, hasLength(2));
    expect(resolution.selected?.type, JourneyType.hajj);
    expect(resolution.selected?.isOfficialHajj, isTrue);

    final umrah = resolution.candidateFor(JourneyType.umrah);
    expect(umrah.isCommercialUmrah, isTrue);
    expect(umrah.context.sourceAuthority, AuthorityKind.commercialCompany);
  });

  test('multiple journeys require explicit selection without preference',
      () async {
    final contexts =
        await const LocalPhase8JourneyCatalog().loadEligibleJourneys();

    final resolution = const UnifiedJourneyResolver().resolve(contexts);

    expect(resolution.hasMultipleJourneys, isTrue);
    expect(resolution.requiresExplicitSelection, isTrue);
    expect(resolution.selected, isNull);
  });

  test('ambiguous same journey id with different authority fails closed',
      () async {
    final contexts =
        await const LocalPhase8JourneyCatalog().loadEligibleJourneys();
    final hajj =
        contexts.firstWhere((item) => item.journeyType == JourneyType.hajj);
    final umrah =
        contexts.firstWhere((item) => item.journeyType == JourneyType.umrah);

    expect(
      () => const UnifiedJourneyResolver().resolve([
        hajj,
        withJourneyId(umrah, hajj.journeyId),
      ]),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          'AMBIGUOUS_JOURNEY_AUTHORITY',
        ),
      ),
    );
  });

  test('offline Umrah snapshot remains explicit', () async {
    final contexts = await const LocalPhase8JourneyCatalog(
      umrahFreshness: JourneyFreshness.offlineSnapshot,
    ).loadEligibleJourneys();

    final resolution = const UnifiedJourneyResolver().resolve(
      contexts,
      preferredType: JourneyType.umrah,
    );

    expect(
      resolution.selected?.freshness,
      JourneyFreshness.offlineSnapshot,
    );
    expect(
      resolution.selected?.freshnessLabelAr,
      contains('دون اتصال'),
    );
  });

  test('Phase 8 local provider has no direct Business database dependency', () {
    final source = File(
      'lib/features/unified_journey/data/phase8_journey_catalog.dart',
    ).readAsStringSync();

    for (final forbidden in const [
      'supabase_flutter',
      'Supabase.instance',
      'nghxemiygpjywkodrdwx',
      'rpc_business_',
      'business.',
    ]) {
      expect(source.contains(forbidden), isFalse);
    }

    expect(source.contains('cross_plane_delivery'), isTrue);
    expect(source.contains('false'), isTrue);
  });
}
