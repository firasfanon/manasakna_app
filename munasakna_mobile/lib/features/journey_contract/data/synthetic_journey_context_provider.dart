import '../domain/journey_context.dart';
import '../domain/journey_context_provider.dart';

class SyntheticJourneyContextProvider implements JourneyContextProvider {
  const SyntheticJourneyContextProvider({
    required this.type,
    this.freshness = JourneyFreshness.fresh,
    this.overrideAuthority,
    this.authoritative = true,
  });

  final JourneyType type;
  final JourneyFreshness freshness;
  final AuthorityKind? overrideAuthority;
  final bool authoritative;

  @override
  String get providerId => 'synthetic-${type.name}-journey-v1';

  @override
  Future<JourneyContext> loadJourneyContext() async {
    final authority = overrideAuthority ??
        (type == JourneyType.hajj
            ? AuthorityKind.government
            : AuthorityKind.commercialCompany);
    final now = DateTime.utc(2026, 9, 18, 12);
    final provenance = AuthorityProvenance(
      sourceAuthority: authority,
      sourceId: providerId,
      observedAt: now,
      isAuthoritative: authoritative,
    );
    JourneySection<T> section<T>(T? value, {AuthorityKind? source}) =>
        JourneySection<T>(
          value: value,
          provenance: AuthorityProvenance(
            sourceAuthority: source ?? authority,
            sourceId: providerId,
            observedAt: now,
            isAuthoritative: authoritative,
          ),
        );

    return JourneyContext(
      schemaVersion: JourneyContext.currentSchemaVersion,
      journeyId: 'synthetic-${type.name}-001',
      journeyType: type,
      travelerContext: {'mode': type.name, 'synthetic': true},
      sourceAuthority: authority,
      authorityProvenance: provenance,
      organizationContext: section({
        'name': type == JourneyType.hajj ? 'حملة تجريبية' : 'شركة عمرة تجريبية'
      }),
      group: section({'name': 'المجموعة التجريبية'},
          source: AuthorityKind.delegatedCompany),
      supervisor: section({'name': 'مشرف تجريبي'},
          source: AuthorityKind.delegatedCompany),
      accommodation: section({'status': 'synthetic'},
          source: AuthorityKind.delegatedCompany),
      room: section({'status': 'synthetic'},
          source: AuthorityKind.delegatedCompany),
      transport: section([
        {'status': 'synthetic'}
      ], source: AuthorityKind.delegatedCompany),
      flights: section([
        {'status': 'synthetic'}
      ], source: AuthorityKind.externalProvider),
      schedule: section([
        {'status': 'synthetic'}
      ], source: AuthorityKind.delegatedCompany),
      meetingPoints: section([
        {'status': 'synthetic'}
      ], source: AuthorityKind.delegatedCompany),
      documents: section([
        {'status': 'synthetic'}
      ]),
      notifications: section([
        {'status': 'synthetic'}
      ]),
      support: section({'status': 'available'},
          source: AuthorityKind.commonTraveler),
      guidance: section([
        {'status': 'synthetic'}
      ], source: AuthorityKind.commonTraveler),
      featureEntitlements: {'journey', 'guidance', 'support'},
      freshness: freshness,
      snapshotAt: now,
    );
  }
}
