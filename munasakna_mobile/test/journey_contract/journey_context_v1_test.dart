import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/features/journey_contract/data/synthetic_journey_context_provider.dart';
import 'package:munasakna_mobile/features/journey_contract/domain/journey_context.dart';
import 'package:munasakna_mobile/features/journey_contract/domain/journey_context_provider.dart';

void main() {
  group('JourneyContext V1 authority contract', () {
    test('Hajj synthetic provider is government authoritative', () async {
      final context = await const JourneyContextGateway(
        SyntheticJourneyContextProvider(type: JourneyType.hajj),
      ).load();
      expect(context.journeyType, JourneyType.hajj);
      expect(context.sourceAuthority, AuthorityKind.government);
      expect(context.authorityProvenance.isAuthoritative, isTrue);
    });

    test('Umrah synthetic provider is company-led', () async {
      final context = await const JourneyContextGateway(
        SyntheticJourneyContextProvider(type: JourneyType.umrah),
      ).load();
      expect(context.journeyType, JourneyType.umrah);
      expect(context.sourceAuthority, AuthorityKind.commercialCompany);
    });

    test('commercial authority cannot own Hajj sovereign journey', () async {
      expect(
        () => const JourneyContextGateway(
          SyntheticJourneyContextProvider(
            type: JourneyType.hajj,
            overrideAuthority: AuthorityKind.commercialCompany,
          ),
        ).load(),
        throwsA(isA<FormatException>()),
      );
    });

    test('ambiguous external authority fails closed', () async {
      expect(
        () => const JourneyContextGateway(
          SyntheticJourneyContextProvider(
            type: JourneyType.umrah,
            overrideAuthority: AuthorityKind.externalProvider,
            authoritative: false,
          ),
        ).load(),
        throwsA(isA<FormatException>()),
      );
    });

    test('unknown freshness fails closed', () async {
      expect(
        () => const JourneyContextGateway(
          SyntheticJourneyContextProvider(
            type: JourneyType.hajj,
            freshness: JourneyFreshness.unknown,
          ),
        ).load(),
        throwsA(isA<FormatException>()),
      );
    });

    test('offline snapshot is explicit and valid', () async {
      final context = await const JourneyContextGateway(
        SyntheticJourneyContextProvider(
          type: JourneyType.umrah,
          freshness: JourneyFreshness.offlineSnapshot,
        ),
      ).load();
      expect(context.freshness, JourneyFreshness.offlineSnapshot);
    });

    test('corrupt envelope is rejected', () {
      expect(
        () => JourneyContext.fromEnvelope(
          {'schema_version': '1.0', 'journey_id': 7},
          buildSections: ({
            required schemaVersion,
            required journeyId,
            required journeyType,
            required travelerContext,
            required sourceAuthority,
            required authorityProvenance,
            required featureEntitlements,
            required freshness,
            required snapshotAt,
          }) =>
              throw UnimplementedError(),
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });
  test('Hajj root rejects delegated company as sovereign authority', () async {
    final provider = SyntheticJourneyContextProvider(
      type: JourneyType.hajj,
      overrideAuthority: AuthorityKind.delegatedCompany,
    );
    await expectLater(
      JourneyContextGateway(provider).load(),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          'HAJJ_ROOT_REQUIRES_AUTHORITATIVE_GOVERNMENT',
        ),
      ),
    );
  });

  test('Hajj root rejects non-authoritative government source', () async {
    final provider = SyntheticJourneyContextProvider(
      type: JourneyType.hajj,
      authoritative: false,
    );
    await expectLater(
      JourneyContextGateway(provider).load(),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          'HAJJ_ROOT_REQUIRES_AUTHORITATIVE_GOVERNMENT',
        ),
      ),
    );
  });
}
