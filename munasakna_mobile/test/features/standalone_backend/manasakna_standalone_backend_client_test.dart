import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:munasakna_mobile/features/standalone_backend/data/manasakna_standalone_backend_client.dart';

void main() {
  const config = ManasaknaStandaloneBackendConfig(
    baseUrl: 'https://example.supabase.co',
    publishableKey: 'publishable-test-key',
  );

  test('loads current season and published content', () async {
    final client = HttpManasaknaStandaloneBackendClient(
      config: config,
      httpClient: MockClient((request) async {
        expect(request.headers['apikey'], 'publishable-test-key');
        if (request.url.path
            .endsWith('rpc_manasakna_public_current_season_v1')) {
          return http.Response(
              jsonEncode(<String, dynamic>{
                'seasonCode': 'SYNTH-H1448',
                'titleAr': 'موسم 1448',
                'status': 'operations',
                'hijriYear': 1448,
                'gregorianYear': 2027,
                'settings': <String, dynamic>{'synthetic': true},
              }),
              200,
              headers: const {
                'content-type': 'application/json; charset=utf-8'
              });
        }
        return http.Response(
            jsonEncode(<Map<String, dynamic>>[
              <String, dynamic>{
                'content_type': 'fatwa',
                'slug': 'test-fatwa',
                'title_ar': 'مادة تجريبية',
                'body_ar': 'محتوى اصطناعي',
                'metadata': <String, dynamic>{'synthetic': true},
                'published_at': '2026-09-14T20:00:00Z',
              }
            ]),
            200,
            headers: const {'content-type': 'application/json; charset=utf-8'});
      }),
    );
    final season = await client.loadCurrentSeason();
    final content = await client.loadContent(contentType: 'fatwa');
    expect(season?.seasonCode, 'SYNTH-H1448');
    expect(season?.hijriYear, 1448);
    expect(content, hasLength(1));
    expect(content.single.titleAr, 'مادة تجريبية');
  });

  test('activation parses governed standalone context', () async {
    final client = HttpManasaknaStandaloneBackendClient(
      config: config,
      httpClient: MockClient((request) async {
        expect(request.url.path, contains('rpc_manasakna_activate_pilgrim_v2'));
        return http.Response(jsonEncode(_activationPayload()), 200,
            headers: const {'content-type': 'application/json; charset=utf-8'});
      }),
    );

    final context = await client.activate('opaque-token-value');
    expect(context.sessionToken, 'session-token-123456');
    expect(context.profile.officialReference, 'SYNTH-01');
    expect(context.profile.isActivationEligible, isTrue);
    expect(context.pack.campaignReference, 'SYNTH-CAMPAIGN');
    expect(context.pack.groupReference, 'SYNTH-GROUP');
    expect(context.pack.schedule, hasLength(1));
  });

  test('authoritative session rejection is surfaced', () async {
    final client = HttpManasaknaStandaloneBackendClient(
      config: config,
      httpClient: MockClient((request) async => http.Response(
          jsonEncode(<String, dynamic>{
            'success': false,
            'code': 'NOT_CURRENTLY_ELIGIBLE',
          }),
          200,
          headers: const {'content-type': 'application/json; charset=utf-8'})),
    );

    expect(
      () => client.revalidate('session-token'),
      throwsA(isA<ManasaknaBackendException>()
          .having((e) => e.authoritative, 'authoritative', isTrue)),
    );
  });
}

Map<String, dynamic> _activationPayload() {
  final issued = '2026-09-14T20:00:00Z';
  final expires = '2026-12-14T20:00:00Z';
  return <String, dynamic>{
    'success': true,
    'sessionToken': 'session-token-123456',
    'sessionExpiresAt': expires,
    'season': <String, dynamic>{
      'seasonCode': 'SYNTH-H1448',
      'titleAr': 'موسم 1448',
      'status': 'operations',
      'hijriYear': 1448,
      'gregorianYear': 2027,
      'settings': <String, dynamic>{'synthetic': true},
    },
    'profile': <String, dynamic>{
      'officialReference': 'SYNTH-01',
      'fullNameAr': 'حاج اصطناعي',
      'acceptanceStatus': 'approved',
      'sourceAuthority': 'manasakna.standalone.synthetic',
      'sourceRevision': 'synthetic-standalone-pilgrim-r1',
      'effectiveAt': issued,
      'campaignReference': 'SYNTH-CAMPAIGN',
      'groupReference': 'SYNTH-GROUP',
      'contractMetadata': _metadata(
        'official-pilgrim-seed.v1',
        issued,
        null,
        integrity: false,
      ),
    },
    'operationalPack': <String, dynamic>{
      'packId': 'pack-1',
      'schemaVersion': 1,
      'campaignReference': 'SYNTH-CAMPAIGN',
      'campaignNameAr': 'حملة اصطناعية',
      'updatedAt': issued,
      'groupReference': 'SYNTH-GROUP',
      'supervisor': <String, dynamic>{
        'roleAr': 'مشرف',
        'nameAr': 'مشرف اصطناعي',
        'phone': '+0000000',
      },
      'meetingPoints': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 'm1',
          'labelAr': 'نقطة',
          'descriptionAr': 'تجريبية',
        }
      ],
      'schedule': <Map<String, dynamic>>[
        <String, dynamic>{
          'id': 's1',
          'titleAr': 'موعد',
          'startsAt': '2026-09-15T01:00:00Z',
        }
      ],
      'emergencyContacts': const <Map<String, dynamic>>[],
      'contractMetadata': _metadata(
        'campaign-operational-pack.v1',
        issued,
        expires,
        integrity: true,
      ),
    },
  };
}

Map<String, dynamic> _metadata(
  String version,
  String issuedAt,
  String? expiresAt, {
  required bool integrity,
}) {
  return <String, dynamic>{
    'contractVersion': version,
    'authorityModel': 'OFFICIAL_HAJJ_SYSTEM',
    'sourceAuthority': 'manasakna.standalone.synthetic',
    'sourceRevision': 'synthetic-test-r1',
    'provenanceReference': 'synthetic://test/context',
    'dataClass': 'syntheticFixture',
    'approvalState': 'approvedForFixtureUse',
    'issuedAt': issuedAt,
    'expiresAt': expiresAt,
    'revoked': false,
    'updateSequence': 1,
    if (integrity) ...<String, dynamic>{
      'integrityAlgorithm': 'SHA-256',
      'integrityDigest': 'abc123',
      'signatureReference': 'synthetic://test/signature',
    },
  };
}
