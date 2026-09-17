import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../season_1448/domain/manasikuna_1448_models.dart';
import '../domain/manasakna_standalone_backend_models.dart';

class ManasaknaStandaloneBackendConfig {
  const ManasaknaStandaloneBackendConfig({
    required this.baseUrl,
    required this.publishableKey,
  });

  factory ManasaknaStandaloneBackendConfig.fromEnvironment() {
    return const ManasaknaStandaloneBackendConfig(
      baseUrl: String.fromEnvironment('MANASAKNA_SUPABASE_URL'),
      publishableKey:
          String.fromEnvironment('MANASAKNA_SUPABASE_PUBLISHABLE_KEY'),
    );
  }

  final String baseUrl;
  final String publishableKey;

  bool get isConfigured =>
      baseUrl.trim().isNotEmpty && _isSafeClientApiKey(publishableKey);

  Uri rpcUri(String functionName) {
    final normalized = baseUrl.trim().replaceFirst(RegExp(r'/$'), '');
    return Uri.parse('$normalized/rest/v1/rpc/$functionName');
  }
}

bool _isSafeClientApiKey(String rawKey) {
  final key = rawKey.trim();
  if (key.isEmpty || key.startsWith('sb_secret_')) return false;
  if (key.startsWith('sb_publishable_')) return true;
  if (key.toLowerCase().contains('service_role')) return false;
  final parts = key.split('.');
  if (parts.length == 3) {
    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      if (payload is Map && payload['role'] == 'service_role') return false;
    } catch (_) {}
  }
  return true;
}

class ManasaknaBackendException implements Exception {
  const ManasaknaBackendException(this.code, {this.authoritative = false});

  final String code;
  final bool authoritative;

  @override
  String toString() => 'ManasaknaBackendException($code)';
}

abstract interface class ManasaknaStandaloneBackendGateway {
  bool get isConfigured;

  Future<ManasaknaStandaloneSeason?> loadCurrentSeason();

  Future<List<ManasaknaPublishedContent>> loadContent({
    String? contentType,
    String? seasonCode,
  });

  Future<List<ManasaknaPublishedNotification>> loadNotifications({
    String? seasonCode,
  });

  Future<ManasaknaBackendActivationContext> activate(String token);

  Future<ManasaknaBackendActivationContext> revalidate(String sessionToken);
}

class HttpManasaknaStandaloneBackendClient
    implements ManasaknaStandaloneBackendGateway {
  HttpManasaknaStandaloneBackendClient({
    required this.config,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  final ManasaknaStandaloneBackendConfig config;
  final http.Client _http;

  @override
  bool get isConfigured => config.isConfigured;

  Map<String, String> get _headers => <String, String>{
        'apikey': config.publishableKey,
        'Authorization': 'Bearer ${config.publishableKey}',
        'Content-Type': 'application/json',
      };

  void _requireConfigured() {
    if (!isConfigured) {
      throw const ManasaknaBackendException('backend_not_configured');
    }
  }

  Future<dynamic> _rpc(
    String functionName,
    Map<String, dynamic> payload,
  ) async {
    _requireConfigured();
    final response = await _http.post(
      config.rpcUri(functionName),
      headers: _headers,
      body: jsonEncode(payload),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ManasaknaBackendException('http_${response.statusCode}');
    }
    if (response.body.trim().isEmpty) {
      return null;
    }
    return jsonDecode(response.body);
  }

  @override
  Future<ManasaknaStandaloneSeason?> loadCurrentSeason() async {
    final decoded = await _rpc(
      'rpc_manasakna_public_current_season_v1',
      const <String, dynamic>{},
    );
    if (decoded == null) return null;
    final map = _asMap(decoded);
    if (map == null || map.isEmpty) return null;
    return _seasonFromJson(map);
  }

  @override
  Future<List<ManasaknaPublishedContent>> loadContent({
    String? contentType,
    String? seasonCode,
  }) async {
    final decoded = await _rpc(
      'rpc_manasakna_public_content_v1',
      <String, dynamic>{
        'p_content_type': contentType,
        'p_season_code': seasonCode,
      },
    );
    if (decoded is! List) return const <ManasaknaPublishedContent>[];
    return decoded
        .whereType<Map>()
        .map((item) => _contentFromJson(Map<String, dynamic>.from(item)))
        .whereType<ManasaknaPublishedContent>()
        .toList(growable: false);
  }

  @override
  Future<List<ManasaknaPublishedNotification>> loadNotifications({
    String? seasonCode,
  }) async {
    final decoded = await _rpc(
      'rpc_manasakna_public_notifications_v1',
      <String, dynamic>{'p_season_code': seasonCode},
    );
    if (decoded is! List) return const <ManasaknaPublishedNotification>[];
    return decoded
        .whereType<Map>()
        .map((item) => _notificationFromJson(Map<String, dynamic>.from(item)))
        .whereType<ManasaknaPublishedNotification>()
        .toList(growable: false);
  }

  @override
  Future<ManasaknaBackendActivationContext> activate(String token) async {
    final decoded = await _rpc(
      'rpc_manasakna_activate_pilgrim_v2',
      <String, dynamic>{'p_token': token.trim()},
    );
    return _activationFromJson(decoded, requireSessionToken: true);
  }

  @override
  Future<ManasaknaBackendActivationContext> revalidate(
      String sessionToken) async {
    final decoded = await _rpc(
      'rpc_manasakna_pilgrim_session_context_v1',
      <String, dynamic>{'p_session_token': sessionToken.trim()},
    );
    return _activationFromJson(
      decoded,
      existingSessionToken: sessionToken.trim(),
    );
  }

  ManasaknaBackendActivationContext _activationFromJson(
    dynamic decoded, {
    String? existingSessionToken,
    bool requireSessionToken = false,
  }) {
    final map = _asMap(decoded);
    if (map == null) {
      throw const ManasaknaBackendException('invalid_backend_payload');
    }
    if (map['success'] != true) {
      throw ManasaknaBackendException(
        (map['code'] as String?) ?? 'activation_rejected',
        authoritative: true,
      );
    }
    final profileMap = _asMap(map['profile']);
    final packMap = _asMap(map['operationalPack']);
    final seasonMap = _asMap(map['season']);
    if (profileMap == null || packMap == null || seasonMap == null) {
      throw const ManasaknaBackendException('context_missing');
    }
    final sessionToken = (map['sessionToken'] as String?)?.trim() ??
        existingSessionToken?.trim() ??
        '';
    if (requireSessionToken && sessionToken.isEmpty) {
      throw const ManasaknaBackendException('session_token_missing');
    }
    final expiresAt = _date(map['sessionExpiresAt']);
    if (expiresAt == null) {
      throw const ManasaknaBackendException('session_expiry_missing');
    }
    return ManasaknaBackendActivationContext(
      profile: _profileFromJson(profileMap),
      pack: _packFromJson(packMap),
      sessionToken: sessionToken,
      sessionExpiresAt: expiresAt,
      season: _seasonFromJson(seasonMap),
    );
  }

  Map<String, dynamic>? _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  ManasaknaStandaloneSeason _seasonFromJson(Map<String, dynamic> json) {
    return ManasaknaStandaloneSeason(
      seasonCode: (json['seasonCode'] as String?) ?? '',
      titleAr: (json['titleAr'] as String?) ?? '',
      status: (json['status'] as String?) ?? '',
      hijriYear: json['hijriYear'] as int?,
      gregorianYear: json['gregorianYear'] as int?,
      settings: _asMap(json['settings']) ?? const <String, dynamic>{},
    );
  }

  ManasaknaPublishedContent? _contentFromJson(Map<String, dynamic> json) {
    final type = json['content_type'] as String?;
    final slug = json['slug'] as String?;
    final title = json['title_ar'] as String?;
    if (type == null || slug == null || title == null) return null;
    return ManasaknaPublishedContent(
      contentType: type,
      slug: slug,
      titleAr: title,
      bodyAr: (json['body_ar'] as String?) ?? '',
      metadata: _asMap(json['metadata']) ?? const <String, dynamic>{},
      publishedAt: _date(json['published_at']),
    );
  }

  ManasaknaPublishedNotification? _notificationFromJson(
    Map<String, dynamic> json,
  ) {
    final id = json['id']?.toString();
    final title = json['title_ar'] as String?;
    final body = json['body_ar'] as String?;
    if (id == null || title == null || body == null) return null;
    return ManasaknaPublishedNotification(
      id: id,
      titleAr: title,
      bodyAr: body,
      audience: _asMap(json['audience']) ?? const <String, dynamic>{},
      publishedAt: _date(json['published_at']),
    );
  }

  DateTime? _date(dynamic value) {
    if (value is! String || value.trim().isEmpty) return null;
    return DateTime.tryParse(value)?.toUtc();
  }

  OfficialPilgrimSeed _profileFromJson(Map<String, dynamic> json) {
    final acceptanceName = json['acceptanceStatus'] as String?;
    final acceptance = OfficialPilgrimAcceptanceStatus.values.firstWhere(
      (item) => item.name == acceptanceName,
      orElse: () => OfficialPilgrimAcceptanceStatus.cancelled,
    );
    final effectiveAt = _date(json['effectiveAt']);
    final metadata = _metadataFromJson(_asMap(json['contractMetadata']));
    if (effectiveAt == null || metadata == null) {
      throw const ManasaknaBackendException('profile_contract_invalid');
    }
    return OfficialPilgrimSeed(
      officialReference: (json['officialReference'] as String?) ?? '',
      fullNameAr: (json['fullNameAr'] as String?) ?? '',
      acceptanceStatus: acceptance,
      sourceAuthority: (json['sourceAuthority'] as String?) ?? '',
      sourceRevision: (json['sourceRevision'] as String?) ?? '',
      effectiveAt: effectiveAt,
      campaignReference: json['campaignReference'] as String?,
      groupReference: json['groupReference'] as String?,
      contractMetadata: metadata,
    );
  }

  CampaignOperationalPack _packFromJson(Map<String, dynamic> json) {
    final updatedAt = _date(json['updatedAt']);
    final metadata = _metadataFromJson(_asMap(json['contractMetadata']));
    if (updatedAt == null || metadata == null) {
      throw const ManasaknaBackendException('pack_contract_invalid');
    }
    return CampaignOperationalPack(
      packId: (json['packId'] as String?) ?? '',
      schemaVersion: (json['schemaVersion'] as int?) ?? 0,
      campaignReference: (json['campaignReference'] as String?) ?? '',
      campaignNameAr: (json['campaignNameAr'] as String?) ?? '',
      updatedAt: updatedAt,
      groupReference: json['groupReference'] as String?,
      supervisor: _contactFromJson(_asMap(json['supervisor'])),
      hotelNameAr: json['hotelNameAr'] as String?,
      hotelAddressAr: json['hotelAddressAr'] as String?,
      transportLabelAr: json['transportLabelAr'] as String?,
      minaCampAr: json['minaCampAr'] as String?,
      arafatCampAr: json['arafatCampAr'] as String?,
      meetingPoints: _meetingPoints(json['meetingPoints']),
      schedule: _schedule(json['schedule']),
      emergencyContacts: _contacts(json['emergencyContacts']),
      contractMetadata: metadata,
    );
  }

  Manasikuna1448ContractMetadata? _metadataFromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) return null;
    final issuedAt = _date(json['issuedAt']);
    if (issuedAt == null) return null;
    final dataClassName = json['dataClass'] as String?;
    final approvalName = json['approvalState'] as String?;
    Manasikuna1448ContractDataClass? dataClass;
    Manasikuna1448ContractApprovalState? approval;
    for (final candidate in Manasikuna1448ContractDataClass.values) {
      if (candidate.name == dataClassName) dataClass = candidate;
    }
    for (final candidate in Manasikuna1448ContractApprovalState.values) {
      if (candidate.name == approvalName) approval = candidate;
    }
    if (dataClass == null || approval == null) return null;
    return Manasikuna1448ContractMetadata(
      contractVersion: (json['contractVersion'] as String?) ?? '',
      authorityModel: (json['authorityModel'] as String?) ?? '',
      sourceAuthority: (json['sourceAuthority'] as String?) ?? '',
      sourceRevision: (json['sourceRevision'] as String?) ?? '',
      provenanceReference: (json['provenanceReference'] as String?) ?? '',
      dataClass: dataClass,
      approvalState: approval,
      issuedAt: issuedAt,
      expiresAt: _date(json['expiresAt']),
      revoked: json['revoked'] == true,
      updateSequence: (json['updateSequence'] as int?) ?? 0,
      integrityAlgorithm: json['integrityAlgorithm'] as String?,
      integrityDigest: json['integrityDigest'] as String?,
      signatureReference: json['signatureReference'] as String?,
    );
  }

  OperationalContact? _contactFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final role = json['roleAr'] as String?;
    final name = json['nameAr'] as String?;
    final phone = json['phone'] as String?;
    if (role == null || name == null || phone == null) return null;
    return OperationalContact(roleAr: role, nameAr: name, phone: phone);
  }

  List<CampaignMeetingPoint> _meetingPoints(dynamic value) {
    if (value is! List) return const <CampaignMeetingPoint>[];
    final result = <CampaignMeetingPoint>[];
    for (final item in value.whereType<Map>()) {
      final map = Map<String, dynamic>.from(item);
      final id = map['id'] as String?;
      final label = map['labelAr'] as String?;
      final description = map['descriptionAr'] as String?;
      if (id == null || label == null || description == null) continue;
      result.add(CampaignMeetingPoint(
        id: id,
        labelAr: label,
        descriptionAr: description,
        latitude: (map['latitude'] as num?)?.toDouble(),
        longitude: (map['longitude'] as num?)?.toDouble(),
      ));
    }
    return result;
  }

  List<CampaignScheduleItem> _schedule(dynamic value) {
    if (value is! List) return const <CampaignScheduleItem>[];
    final result = <CampaignScheduleItem>[];
    for (final item in value.whereType<Map>()) {
      final map = Map<String, dynamic>.from(item);
      final id = map['id'] as String?;
      final title = map['titleAr'] as String?;
      final startsAt = _date(map['startsAt']);
      if (id == null || title == null || startsAt == null) continue;
      result.add(CampaignScheduleItem(
        id: id,
        titleAr: title,
        startsAt: startsAt,
        endsAt: _date(map['endsAt']),
        meetingPointId: map['meetingPointId'] as String?,
        notesAr: map['notesAr'] as String?,
      ));
    }
    return result;
  }

  List<OperationalContact> _contacts(dynamic value) {
    if (value is! List) return const <OperationalContact>[];
    return value
        .whereType<Map>()
        .map((item) => _contactFromJson(Map<String, dynamic>.from(item)))
        .whereType<OperationalContact>()
        .toList(growable: false);
  }
}
