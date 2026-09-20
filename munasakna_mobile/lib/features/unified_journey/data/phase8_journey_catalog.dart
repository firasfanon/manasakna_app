import '../../journey_contract/data/synthetic_journey_context_provider.dart';
import '../../journey_contract/domain/journey_context.dart';
import '../../journey_contract/domain/journey_context_provider.dart';

abstract interface class Phase8JourneyCatalog {
  Future<List<JourneyContext>> loadEligibleJourneys();
}

class LocalPhase8JourneyCatalog implements Phase8JourneyCatalog {
  const LocalPhase8JourneyCatalog({
    this.umrahFreshness = JourneyFreshness.fresh,
  });

  final JourneyFreshness umrahFreshness;

  @override
  Future<List<JourneyContext>> loadEligibleJourneys() async {
    final hajj = await const JourneyContextGateway(
      SyntheticJourneyContextProvider(type: JourneyType.hajj),
    ).load();
    final umrah = await JourneyContextGateway(
      CommercialUmrahLocalJourneyProvider(freshness: umrahFreshness),
    ).load();

    return [hajj, umrah];
  }
}

class CommercialUmrahLocalJourneyProvider implements JourneyContextProvider {
  const CommercialUmrahLocalJourneyProvider({
    this.freshness = JourneyFreshness.fresh,
  });

  final JourneyFreshness freshness;

  @override
  String get providerId => 'manasakna-business-contract-fixture-v1';

  @override
  Future<JourneyContext> loadJourneyContext() async {
    final now = DateTime.utc(2026, 9, 20, 9, 30);
    final rootProvenance = AuthorityProvenance(
      sourceAuthority: AuthorityKind.commercialCompany,
      sourceId: providerId,
      observedAt: now,
      isAuthoritative: true,
    );

    JourneySection<T> commercial<T>(T? value) => JourneySection<T>(
          value: value,
          provenance: AuthorityProvenance(
            sourceAuthority: AuthorityKind.commercialCompany,
            sourceId: providerId,
            observedAt: now,
            isAuthoritative: true,
          ),
        );

    JourneySection<T> common<T>(T? value) => JourneySection<T>(
          value: value,
          provenance: AuthorityProvenance(
            sourceAuthority: AuthorityKind.commonTraveler,
            sourceId: 'manasakna-common-traveler-v1',
            observedAt: now,
            isAuthoritative: true,
          ),
        );

    JourneySection<T> external<T>(T? value) => JourneySection<T>(
          value: value,
          provenance: AuthorityProvenance(
            sourceAuthority: AuthorityKind.externalProvider,
            sourceId: 'synthetic-provider-fixture-v1',
            observedAt: now,
            isAuthoritative: true,
          ),
        );

    final context = JourneyContext(
      schemaVersion: JourneyContext.currentSchemaVersion,
      journeyId: 'commercial-umrah-synthetic-001',
      journeyType: JourneyType.umrah,
      travelerContext: const {
        'traveler_role': 'primary',
        'data_classification': 'synthetic',
        'cross_plane_delivery': false,
      },
      sourceAuthority: AuthorityKind.commercialCompany,
      authorityProvenance: rootProvenance,
      organizationContext: commercial(const {
        'name': 'شركة العمرة التجريبية',
        'authority_label': 'commercial_company',
      }),
      group: commercial(const {
        'name': 'مجموعة العمرة التجريبية',
      }),
      supervisor: commercial(const {
        'name': 'مشرف الشركة',
        'contact_visibility': 'traveler_safe',
      }),
      accommodation: commercial(const {
        'property_name': 'إقامة تجريبية',
        'city': 'مكة المكرمة',
      }),
      room: commercial(const {
        'room_label': 'SYN-101',
      }),
      transport: commercial(const [
        {
          'mode': 'bus',
          'pickup': 'مطار جدة',
          'dropoff': 'مكة المكرمة',
        }
      ]),
      flights: external(const [
        {
          'flight_number': 'SYN700',
          'origin': 'AMM',
          'destination': 'JED',
        }
      ]),
      schedule: commercial(const [
        {
          'title': 'الوصول والاستقبال',
          'status': 'planned',
        },
        {
          'title': 'مناسك العمرة',
          'status': 'planned',
        },
      ]),
      meetingPoints: commercial(const [
        {
          'label': 'نقطة التجمع التجريبية',
        }
      ]),
      documents: commercial(const [
        {
          'type': 'passport',
          'status': 'verified',
          'reference': 'synthetic-only',
        },
        {
          'type': 'visa',
          'status': 'approved',
          'authority_source': 'synthetic-regulatory-source',
        },
      ]),
      notifications: commercial(const [
        {
          'title': 'تذكير الرحلة',
          'status': 'scheduled',
        }
      ]),
      support: common(const {
        'status': 'available',
        'channel': 'traveler_support',
      }),
      guidance: common(const [
        {
          'title': 'إرشادات العمرة',
          'status': 'available',
        }
      ]),
      featureEntitlements: const {
        'journey',
        'guidance',
        'support',
        'documents',
        'accommodation',
        'transport',
      },
      freshness: freshness,
      snapshotAt: now,
    );

    context.validate();
    return context;
  }
}
