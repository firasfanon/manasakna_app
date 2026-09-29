import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:munasakna_mobile/features/cross_plane_gateway/data/phase9_cross_plane_journey_catalog.dart';
import 'package:munasakna_mobile/features/cross_plane_gateway/domain/cross_plane_gateway.dart';
import 'package:munasakna_mobile/features/journey_contract/domain/journey_context.dart';
import 'package:munasakna_mobile/features/unified_journey/domain/unified_journey_resolution.dart';

CrossPlaneGatewayRequest request({
  String requestId = 'req-001',
  String bookingId = 'booking-1',
}) {
  return CrossPlaneGatewayRequest(
    contractVersion: phase9CrossPlaneContractVersion,
    requestId: requestId,
    idempotencyKey: 'idem-001',
    requestedAt: DateTime.utc(2026, 9, 23, 20),
    identity: const CrossPlaneServiceIdentity(
      serviceId: phase9ConsumerServiceId,
      audience: phase9BusinessAudience,
      scopes: {phase9TravelerProjectionScope},
    ),
    journeyType: 'umrah',
    tenantId: 'tenant-1',
    bookingId: bookingId,
    requestedFields: phase9AllowedProjectionFields,
  );
}

Map<String, Object?> validResponse({
  String requestId = 'req-001',
  String bookingId = 'booking-1',
}) {
  final observed = DateTime.utc(2026, 9, 23, 20, 15).toIso8601String();
  return {
    'contract_version': phase9CrossPlaneContractVersion,
    'request_id': requestId,
    'event_id': 'business-gateway:$requestId',
    'source_project': phase9BusinessSourceProject,
    'source_authority': 'commercialCompany',
    'subject_ref': bookingId,
    'observed_at': observed,
    'source_schema_version': 'commercial-umrah-journey-context-v1',
    'journey_id': bookingId,
    'journey_type': 'umrah',
    'authority_provenance': {
      'source_authority': 'commercialCompany',
      'source_id': phase9BusinessSourceProject,
      'observed_at': observed,
      'is_authoritative': true,
    },
    'projection': {
      'organization': {'tenant_name': 'شركة تجريبية'},
      'booking': {'booking_code': 'B-001'},
      'package': {'name': 'عمرة تجريبية'},
      'traveler_summary': {'count': 2},
      'accommodation': {'room_label': 'SYN-101'},
      'flight_summary': {'count': 1},
      'freshness': 'fresh',
    },
  };
}

void main() {
  test('shared Phase 9 contract manifest is DB-isolated', () {
    final manifest = jsonDecode(
      File('../docs/MANASAKNA_CROSS_PLANE_GATEWAY_CONTRACT_V1.json')
          .readAsStringSync(),
    ) as Map<String, dynamic>;
    expect(manifest['contract_version'], phase9CrossPlaneContractVersion);
    expect(manifest['direct_cross_plane_db_access'], isFalse);
    expect(manifest['synthetic_non_production_default'], isTrue);
    expect(
      Set<String>.from(manifest['allowed_projection_fields'] as List),
      phase9AllowedProjectionFields,
    );
  });

  test('synthetic gateway maps to commercial Umrah JourneyContext', () async {
    final transport = SyntheticCrossPlaneGatewayTransport();
    final context = await CrossPlaneGatewayClient(transport).load(request());
    expect(context.journeyType, JourneyType.umrah);
    expect(context.sourceAuthority, AuthorityKind.commercialCompany);
    expect(context.authorityProvenance.sourceId, phase9BusinessSourceProject);
    expect(context.travelerContext['cross_plane_delivery'], isTrue);
    expect(context.travelerContext['booking_code'], 'B-SYN-001');
    expect(context.travelerContext['traveler_count'], 2);
    expect(context.room.value?['room_label'], 'SYN-101');
    expect(context.freshness, JourneyFreshness.fresh);
    final identity = transport.lastRequest?['service_identity'] as Map;
    expect(identity['service_id'], phase9ConsumerServiceId);
    expect(identity['audience'], phase9BusinessAudience);
  });

  test('response request mismatch fails closed', () async {
    final transport = SyntheticCrossPlaneGatewayTransport(
      responseOverride: validResponse(requestId: 'wrong-request'),
    );
    await expectLater(
      CrossPlaneGatewayClient(transport).load(request()),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          'CROSS_PLANE_REQUEST_CORRELATION_MISMATCH',
        ),
      ),
    );
  });

  test('Hajj response from commercial plane is prohibited', () async {
    final response = validResponse()..['journey_type'] = 'hajj';
    await expectLater(
      CrossPlaneGatewayClient(
        SyntheticCrossPlaneGatewayTransport(responseOverride: response),
      ).load(request()),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          'CROSS_PLANE_HAJJ_RESPONSE_PROHIBITED',
        ),
      ),
    );
  });

  test('forbidden nested commercial internals are rejected', () async {
    final response = validResponse();
    final projection = Map<String, Object?>.from(response['projection'] as Map);
    projection['booking'] = {
      'booking_code': 'B-001',
      'finance': {'balance': 99},
    };
    response['projection'] = projection;
    await expectLater(
      CrossPlaneGatewayClient(
        SyntheticCrossPlaneGatewayTransport(responseOverride: response),
      ).load(request()),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          'FORBIDDEN_GATEWAY_FIELD:finance',
        ),
      ),
    );
  });

  test('unknown freshness fails closed', () async {
    final response = validResponse();
    final projection = Map<String, Object?>.from(response['projection'] as Map)
      ..['freshness'] = 'unknown';
    response['projection'] = projection;
    await expectLater(
      CrossPlaneGatewayClient(
        SyntheticCrossPlaneGatewayTransport(responseOverride: response),
      ).load(request()),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          'INVALID_CROSS_PLANE_FRESHNESS',
        ),
      ),
    );
  });

  test('Phase 9 catalog preserves separate Hajj and Umrah authority', () async {
    final contexts =
        await Phase9CrossPlaneJourneyCatalog().loadEligibleJourneys();
    final resolution = const UnifiedJourneyResolver().resolve(
      contexts,
      preferredType: JourneyType.umrah,
    );
    expect(resolution.candidates, hasLength(2));
    expect(resolution.selected?.isCommercialUmrah, isTrue);
    expect(resolution.candidateFor(JourneyType.hajj).isOfficialHajj, isTrue);
  });

  test('gateway source has no direct Business database dependency', () {
    final source = File(
      'lib/features/cross_plane_gateway/domain/cross_plane_gateway.dart',
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
  });

  test('HTTP transport rejects insecure non-local endpoint before network',
      () async {
    final transport = HttpCrossPlaneGatewayTransport(
      endpoint: Uri.parse('http://example.test/gateway'),
      client: NeverCalledHttpClient(),
    );
    await expectLater(
      transport.send(request().toJson()),
      throwsA(isA<FormatException>()),
    );
  });
}

class NeverCalledHttpClient extends BaseClient {
  @override
  Future<StreamedResponse> send(BaseRequest request) {
    throw StateError('HTTP client must not be called');
  }
}
