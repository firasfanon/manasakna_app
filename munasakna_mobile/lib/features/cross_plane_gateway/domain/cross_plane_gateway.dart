import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../journey_contract/domain/journey_context.dart';
import '../../journey_contract/domain/journey_context_provider.dart';

const phase9CrossPlaneContractVersion = 'manasakna-cross-plane-gateway-v1';
const phase9TravelerProjectionScope = 'journey.read.traveler_projection';
const phase9ConsumerServiceId = 'manasakna-app-phase9';
const phase9BusinessAudience = 'manasakna-business-phase9';
const phase9BusinessSourceProject = 'MANASAKNA_BUSINESS';

const phase9AllowedProjectionFields = <String>{
  'organization',
  'booking',
  'package',
  'traveler_summary',
  'accommodation',
  'flight_summary',
  'freshness',
};

const phase9ForbiddenProjectionFields = <String>{
  'customer_name',
  'full_name',
  'passport_reference',
  'document_reference',
  'finance',
  'payment',
  'payments',
  'margin',
  'commission',
  'supplier_payables',
  'lead',
  'quote',
};

class CrossPlaneServiceIdentity {
  const CrossPlaneServiceIdentity({
    required this.serviceId,
    required this.audience,
    required this.scopes,
  });

  final String serviceId;
  final String audience;
  final Set<String> scopes;

  void validate() {
    if (serviceId != phase9ConsumerServiceId) {
      throw const FormatException('UNAUTHORIZED_GATEWAY_SERVICE_ID');
    }
    if (audience != phase9BusinessAudience) {
      throw const FormatException('INVALID_GATEWAY_AUDIENCE');
    }
    if (!scopes.contains(phase9TravelerProjectionScope)) {
      throw const FormatException('MISSING_TRAVELER_PROJECTION_SCOPE');
    }
    if (scopes.any((scope) => scope.toLowerCase().startsWith('hajj.'))) {
      throw const FormatException(
          'HAJJ_SCOPE_PROHIBITED_ON_COMMERCIAL_GATEWAY');
    }
  }

  Map<String, Object?> toJson() => {
        'service_id': serviceId,
        'audience': audience,
        'scopes': scopes.toList()..sort(),
      };

  factory CrossPlaneServiceIdentity.fromJson(Map<String, Object?> json) {
    final scopes = json['scopes'];
    if (scopes is! List) {
      throw const FormatException('INVALID_GATEWAY_SCOPES');
    }
    final identity = CrossPlaneServiceIdentity(
      serviceId: _requiredString(json, 'service_id'),
      audience: _requiredString(json, 'audience'),
      scopes: scopes.whereType<String>().toSet(),
    );
    identity.validate();
    return identity;
  }
}

class CrossPlaneGatewayRequest {
  const CrossPlaneGatewayRequest({
    required this.contractVersion,
    required this.requestId,
    required this.idempotencyKey,
    required this.requestedAt,
    required this.identity,
    required this.journeyType,
    required this.tenantId,
    required this.bookingId,
    required this.requestedFields,
  });

  final String contractVersion;
  final String requestId;
  final String idempotencyKey;
  final DateTime requestedAt;
  final CrossPlaneServiceIdentity identity;
  final String journeyType;
  final String tenantId;
  final String bookingId;
  final Set<String> requestedFields;

  void validate() {
    if (contractVersion != phase9CrossPlaneContractVersion) {
      throw const FormatException('UNSUPPORTED_CROSS_PLANE_CONTRACT_VERSION');
    }
    if (requestId.trim().isEmpty || idempotencyKey.trim().isEmpty) {
      throw const FormatException('INVALID_GATEWAY_REQUEST_IDENTITY');
    }
    if (!requestedAt.isUtc) {
      throw const FormatException('GATEWAY_REQUEST_TIME_MUST_BE_UTC');
    }
    identity.validate();
    if (journeyType != 'umrah') {
      throw const FormatException('COMMERCIAL_GATEWAY_UMRAH_ONLY');
    }
    if (tenantId.trim().isEmpty || bookingId.trim().isEmpty) {
      throw const FormatException('INVALID_GATEWAY_SUBJECT');
    }
    if (requestedFields.isEmpty ||
        requestedFields.difference(phase9AllowedProjectionFields).isNotEmpty) {
      throw const FormatException('UNAUTHORIZED_GATEWAY_FIELD_REQUEST');
    }
  }

  Map<String, Object?> toJson() => {
        'contract_version': contractVersion,
        'request_id': requestId,
        'idempotency_key': idempotencyKey,
        'requested_at': requestedAt.toUtc().toIso8601String(),
        'service_identity': identity.toJson(),
        'journey_type': journeyType,
        'tenant_id': tenantId,
        'booking_id': bookingId,
        'requested_fields': requestedFields.toList()..sort(),
      };

  factory CrossPlaneGatewayRequest.fromJson(Map<String, Object?> json) {
    final at = DateTime.tryParse(_requiredString(json, 'requested_at'));
    final identityRaw = json['service_identity'];
    final fields = json['requested_fields'];
    if (at == null || identityRaw is! Map || fields is! List) {
      throw const FormatException('INVALID_GATEWAY_REQUEST_ENVELOPE');
    }
    final request = CrossPlaneGatewayRequest(
      contractVersion: _requiredString(json, 'contract_version'),
      requestId: _requiredString(json, 'request_id'),
      idempotencyKey: _requiredString(json, 'idempotency_key'),
      requestedAt: at.toUtc(),
      identity: CrossPlaneServiceIdentity.fromJson(
        Map<String, Object?>.from(identityRaw),
      ),
      journeyType: _requiredString(json, 'journey_type'),
      tenantId: _requiredString(json, 'tenant_id'),
      bookingId: _requiredString(json, 'booking_id'),
      requestedFields: fields.whereType<String>().toSet(),
    );
    request.validate();
    return request;
  }
}

class CrossPlaneGatewayResponse {
  const CrossPlaneGatewayResponse({
    required this.contractVersion,
    required this.requestId,
    required this.eventId,
    required this.sourceProject,
    required this.sourceAuthority,
    required this.subjectRef,
    required this.observedAt,
    required this.sourceSchemaVersion,
    required this.journeyId,
    required this.journeyType,
    required this.projection,
  });

  final String contractVersion;
  final String requestId;
  final String eventId;
  final String sourceProject;
  final String sourceAuthority;
  final String subjectRef;
  final DateTime observedAt;
  final String sourceSchemaVersion;
  final String journeyId;
  final String journeyType;
  final Map<String, Object?> projection;

  factory CrossPlaneGatewayResponse.fromJson(Map<String, Object?> json) {
    final at = DateTime.tryParse(_requiredString(json, 'observed_at'));
    final projectionRaw = json['projection'];
    final provenanceRaw = json['authority_provenance'];
    if (at == null || projectionRaw is! Map || provenanceRaw is! Map) {
      throw const FormatException('INVALID_CROSS_PLANE_RESPONSE_ENVELOPE');
    }
    final projection = Map<String, Object?>.from(projectionRaw);
    if (projection.keys
        .toSet()
        .difference(phase9AllowedProjectionFields)
        .isNotEmpty) {
      throw const FormatException('UNAUTHORIZED_GATEWAY_RESPONSE_FIELD');
    }
    _assertProjectionIsMinimized(projection);

    final response = CrossPlaneGatewayResponse(
      contractVersion: _requiredString(json, 'contract_version'),
      requestId: _requiredString(json, 'request_id'),
      eventId: _requiredString(json, 'event_id'),
      sourceProject: _requiredString(json, 'source_project'),
      sourceAuthority: _requiredString(json, 'source_authority'),
      subjectRef: _requiredString(json, 'subject_ref'),
      observedAt: at.toUtc(),
      sourceSchemaVersion: _requiredString(json, 'source_schema_version'),
      journeyId: _requiredString(json, 'journey_id'),
      journeyType: _requiredString(json, 'journey_type'),
      projection: Map.unmodifiable(projection),
    );
    response._validateProvenance(Map<String, Object?>.from(provenanceRaw));
    response.validate();
    return response;
  }

  void validate() {
    if (contractVersion != phase9CrossPlaneContractVersion) {
      throw const FormatException('UNSUPPORTED_CROSS_PLANE_CONTRACT_VERSION');
    }
    if (sourceProject != phase9BusinessSourceProject) {
      throw const FormatException('INVALID_CROSS_PLANE_SOURCE_PROJECT');
    }
    if (sourceAuthority != 'commercialCompany') {
      throw const FormatException('INVALID_CROSS_PLANE_SOURCE_AUTHORITY');
    }
    if (sourceSchemaVersion != 'commercial-umrah-journey-context-v1') {
      throw const FormatException('UNSUPPORTED_COMMERCIAL_SOURCE_SCHEMA');
    }
    if (journeyType != 'umrah') {
      throw const FormatException('CROSS_PLANE_HAJJ_RESPONSE_PROHIBITED');
    }
    _parseFreshness(projection['freshness']);
  }

  void _validateProvenance(Map<String, Object?> provenance) {
    if (_requiredString(provenance, 'source_authority') != sourceAuthority ||
        _requiredString(provenance, 'source_id') != sourceProject ||
        provenance['is_authoritative'] != true) {
      throw const FormatException('CROSS_PLANE_PROVENANCE_MISMATCH');
    }
    final pAt = DateTime.tryParse(_requiredString(provenance, 'observed_at'));
    if (pAt == null || pAt.toUtc() != observedAt.toUtc()) {
      throw const FormatException('CROSS_PLANE_PROVENANCE_TIME_MISMATCH');
    }
  }

  JourneyContext toJourneyContext() {
    validate();
    final provenance = AuthorityProvenance(
      sourceAuthority: AuthorityKind.commercialCompany,
      sourceId: sourceProject,
      observedAt: observedAt,
      isAuthoritative: true,
    );
    JourneySection<T> commercial<T>(T? value) =>
        JourneySection<T>(value: value, provenance: provenance);

    final organization = _objectMap(projection['organization']);
    final booking = _objectMap(projection['booking']);
    final package = _objectMap(projection['package']);
    final accommodation = _objectMap(projection['accommodation']);
    final travelerCount =
        _safeInt(_objectMap(projection['traveler_summary'])['count']);
    final flightCount =
        _safeInt(_objectMap(projection['flight_summary'])['count']);
    final roomLabel = accommodation['room_label'];
    final entitlements = <String>{'journey'};
    if (accommodation.isNotEmpty) entitlements.add('accommodation');
    if (flightCount > 0) entitlements.add('transport');

    final travelerContext = <String, Object?>{
      'data_classification': 'traveler_safe',
      'cross_plane_delivery': true,
      'source_project': sourceProject,
      'source_schema_version': sourceSchemaVersion,
      'booking_code': booking['booking_code'],
      'package_name': package['name'],
      'traveler_count': travelerCount,
      'flight_count': flightCount,
    }..removeWhere((key, value) => value == null);

    final context = JourneyContext(
      schemaVersion: JourneyContext.currentSchemaVersion,
      journeyId: journeyId,
      journeyType: JourneyType.umrah,
      travelerContext: travelerContext,
      sourceAuthority: AuthorityKind.commercialCompany,
      authorityProvenance: provenance,
      organizationContext: commercial(organization),
      group: commercial(const <String, Object?>{}),
      supervisor: commercial(const <String, Object?>{}),
      accommodation: commercial(accommodation),
      room: commercial(roomLabel == null
          ? const <String, Object?>{}
          : <String, Object?>{'room_label': roomLabel}),
      transport: commercial(const <Map<String, Object?>>[]),
      flights: commercial(flightCount <= 0
          ? const <Map<String, Object?>>[]
          : <Map<String, Object?>>[
              {'count': flightCount, 'detail_level': 'summary'}
            ]),
      schedule: commercial(const <Map<String, Object?>>[]),
      meetingPoints: commercial(const <Map<String, Object?>>[]),
      documents: commercial(const <Map<String, Object?>>[]),
      notifications: commercial(const <Map<String, Object?>>[]),
      support: commercial(const <String, Object?>{}),
      guidance: commercial(const <Map<String, Object?>>[]),
      featureEntitlements: entitlements,
      freshness: _parseFreshness(projection['freshness']),
      snapshotAt: observedAt,
    );
    context.validate();
    return context;
  }
}

abstract interface class CrossPlaneGatewayTransport {
  Future<Map<String, Object?>> send(Map<String, Object?> request);
}

class CrossPlaneGatewayClient {
  const CrossPlaneGatewayClient(this.transport);

  final CrossPlaneGatewayTransport transport;

  Future<JourneyContext> load(CrossPlaneGatewayRequest request) async {
    request.validate();
    final response = CrossPlaneGatewayResponse.fromJson(
        await transport.send(request.toJson()));
    if (response.requestId != request.requestId) {
      throw const FormatException('CROSS_PLANE_REQUEST_CORRELATION_MISMATCH');
    }
    if (response.subjectRef != request.bookingId) {
      throw const FormatException('CROSS_PLANE_SUBJECT_CORRELATION_MISMATCH');
    }
    return response.toJourneyContext();
  }
}

class CommercialUmrahCrossPlaneProvider implements JourneyContextProvider {
  const CommercialUmrahCrossPlaneProvider({
    required this.client,
    required this.request,
  });

  final CrossPlaneGatewayClient client;
  final CrossPlaneGatewayRequest request;

  @override
  String get providerId => 'phase9-cross-plane-commercial-umrah-v1';

  @override
  Future<JourneyContext> loadJourneyContext() => client.load(request);
}

class SyntheticCrossPlaneGatewayTransport
    implements CrossPlaneGatewayTransport {
  SyntheticCrossPlaneGatewayTransport({
    DateTime? observedAt,
    this.freshness = 'fresh',
    this.responseOverride,
  }) : observedAt = (observedAt ?? DateTime.utc(2026, 9, 23, 20, 15)).toUtc();

  final DateTime observedAt;
  final String freshness;
  final Map<String, Object?>? responseOverride;
  Map<String, Object?>? lastRequest;

  @override
  Future<Map<String, Object?>> send(Map<String, Object?> requestJson) async {
    lastRequest = Map<String, Object?>.from(requestJson);
    final request = CrossPlaneGatewayRequest.fromJson(requestJson);
    if (responseOverride != null) {
      return Map<String, Object?>.from(responseOverride!);
    }
    final projection = <String, Object?>{};
    if (request.requestedFields.contains('organization')) {
      projection['organization'] = {'tenant_name': 'شركة العمرة التجريبية'};
    }
    if (request.requestedFields.contains('booking')) {
      projection['booking'] = {'booking_code': 'B-SYN-001'};
    }
    if (request.requestedFields.contains('package')) {
      projection['package'] = {'name': 'عمرة تجريبية'};
    }
    if (request.requestedFields.contains('traveler_summary')) {
      projection['traveler_summary'] = {'count': 2};
    }
    if (request.requestedFields.contains('accommodation')) {
      projection['accommodation'] = {'room_label': 'SYN-101'};
    }
    if (request.requestedFields.contains('flight_summary')) {
      projection['flight_summary'] = {'count': 1};
    }
    if (request.requestedFields.contains('freshness')) {
      projection['freshness'] = freshness;
    }
    return {
      'contract_version': phase9CrossPlaneContractVersion,
      'request_id': request.requestId,
      'event_id': 'business-gateway:${request.requestId}',
      'source_project': phase9BusinessSourceProject,
      'source_authority': 'commercialCompany',
      'subject_ref': request.bookingId,
      'observed_at': observedAt.toIso8601String(),
      'source_schema_version': 'commercial-umrah-journey-context-v1',
      'journey_id': request.bookingId,
      'journey_type': 'umrah',
      'authority_provenance': {
        'source_authority': 'commercialCompany',
        'source_id': phase9BusinessSourceProject,
        'observed_at': observedAt.toIso8601String(),
        'is_authoritative': true,
      },
      'projection': projection,
    };
  }
}

class HttpCrossPlaneGatewayTransport implements CrossPlaneGatewayTransport {
  HttpCrossPlaneGatewayTransport({
    required this.endpoint,
    required this.client,
    this.headers = const {},
    this.timeout = const Duration(seconds: 10),
  });

  final Uri endpoint;
  final http.Client client;
  final Map<String, String> headers;
  final Duration timeout;

  @override
  Future<Map<String, Object?>> send(Map<String, Object?> request) async {
    final localhost =
        endpoint.host == 'localhost' || endpoint.host == '127.0.0.1';
    if (endpoint.scheme != 'https' && !localhost) {
      throw const FormatException('INSECURE_CROSS_PLANE_ENDPOINT');
    }
    final response = await client
        .post(
          endpoint,
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'x-manasakna-contract-version': phase9CrossPlaneContractVersion,
            ...headers,
          },
          body: jsonEncode(request),
        )
        .timeout(timeout);
    if (response.statusCode != 200) {
      throw FormatException(
        'CROSS_PLANE_HTTP_STATUS_${response.statusCode}',
      );
    }
    final decoded = jsonDecode(response.body);
    if (decoded is! Map) {
      throw const FormatException('INVALID_CROSS_PLANE_HTTP_RESPONSE');
    }
    return Map<String, Object?>.from(decoded);
  }
}

JourneyFreshness _parseFreshness(Object? raw) {
  switch (raw) {
    case 'fresh':
      return JourneyFreshness.fresh;
    case 'stale':
      return JourneyFreshness.stale;
    case 'offlineSnapshot':
      return JourneyFreshness.offlineSnapshot;
    default:
      throw const FormatException('INVALID_CROSS_PLANE_FRESHNESS');
  }
}

Map<String, Object?> _objectMap(Object? raw) {
  if (raw is! Map) return const <String, Object?>{};
  return raw.map((key, value) => MapEntry(key.toString(), value));
}

int _safeInt(Object? raw) {
  if (raw is int && raw >= 0) return raw;
  final parsed = int.tryParse(raw?.toString() ?? '');
  if (parsed == null || parsed < 0) return 0;
  return parsed;
}

void _assertProjectionIsMinimized(Object? value) {
  if (value is Map) {
    for (final entry in value.entries) {
      final key = entry.key.toString();
      if (phase9ForbiddenProjectionFields.contains(key)) {
        throw FormatException('FORBIDDEN_GATEWAY_FIELD:$key');
      }
      _assertProjectionIsMinimized(entry.value);
    }
  } else if (value is Iterable) {
    for (final item in value) {
      _assertProjectionIsMinimized(item);
    }
  }
}

String _requiredString(Map<String, Object?> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('INVALID_GATEWAY_FIELD:$key');
  }
  return value;
}
