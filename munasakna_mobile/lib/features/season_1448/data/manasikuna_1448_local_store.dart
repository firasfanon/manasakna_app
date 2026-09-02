import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/manasikuna_1448_launch_models.dart';
import '../domain/manasikuna_1448_models.dart';

class Manasikuna1448LocalStore {
  const Manasikuna1448LocalStore();

  static const String snapshotKey = 'manasikuna_1448_launch_snapshot_v1';
  static const int snapshotSchemaVersion = 1;
  static const int supportedPackSchemaVersion = 1;

  Future<void> save(Manasikuna1448LaunchSession session) async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_sessionToJson(session));
    await preferences.setString(snapshotKey, encoded);
  }

  Future<Manasikuna1448LaunchSession?> restore() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(snapshotKey);
    if (raw == null || raw.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        return _rejectSnapshot(preferences);
      }

      final session = _sessionFromJson(
        Map<String, dynamic>.from(decoded),
      );

      if (session == null || !_isSemanticallyValidForRestore(session)) {
        return _rejectSnapshot(preferences);
      }

      return session;
    } catch (_) {
      return _rejectSnapshot(preferences);
    }
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(snapshotKey);
  }

  Future<Manasikuna1448LaunchSession?> _rejectSnapshot(
    SharedPreferences preferences,
  ) async {
    await preferences.remove(snapshotKey);
    return null;
  }

  bool _isSemanticallyValidForRestore(
    Manasikuna1448LaunchSession session,
  ) {
    if (!session.profile.isActivationEligible) {
      return false;
    }

    if (session.pack.schemaVersion != supportedPackSchemaVersion) {
      return false;
    }

    final profileCampaign = _trimmedOrNull(
      session.profile.campaignReference,
    );
    if (profileCampaign == null ||
        session.pack.campaignReference.trim() != profileCampaign) {
      return false;
    }

    final profileGroup = _trimmedOrNull(session.profile.groupReference);
    final packGroup = _trimmedOrNull(session.pack.groupReference);
    if (profileGroup != packGroup) {
      return false;
    }

    if (!session.credentialExpiresAtUtc
        .toUtc()
        .isAfter(session.activatedAtUtc.toUtc())) {
      return false;
    }

    if (session.savedAtUtc.toUtc().isBefore(session.activatedAtUtc.toUtc())) {
      return false;
    }

    return true;
  }

  String? _trimmedOrNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  Map<String, dynamic> _sessionToJson(
    Manasikuna1448LaunchSession session,
  ) {
    return <String, dynamic>{
      'schemaVersion': snapshotSchemaVersion,
      'activatedAtUtc': session.activatedAtUtc.toUtc().toIso8601String(),
      'credentialExpiresAtUtc':
          session.credentialExpiresAtUtc.toUtc().toIso8601String(),
      'savedAtUtc': session.savedAtUtc.toUtc().toIso8601String(),
      'profile': _profileToJson(session.profile),
      'pack': _packToJson(session.pack),
    };
  }

  Manasikuna1448LaunchSession? _sessionFromJson(
    Map<String, dynamic> json,
  ) {
    if (json['schemaVersion'] != snapshotSchemaVersion) {
      return null;
    }

    final profileJson = json['profile'];
    final packJson = json['pack'];
    if (profileJson is! Map || packJson is! Map) {
      return null;
    }

    final profile = _profileFromJson(
      Map<String, dynamic>.from(profileJson),
    );
    final pack = _packFromJson(
      Map<String, dynamic>.from(packJson),
    );

    if (profile == null || pack == null) {
      return null;
    }

    final activatedAtUtc = _date(json['activatedAtUtc']);
    final credentialExpiresAtUtc = _date(json['credentialExpiresAtUtc']);
    final savedAtUtc = _date(json['savedAtUtc']);

    if (activatedAtUtc == null ||
        credentialExpiresAtUtc == null ||
        savedAtUtc == null) {
      return null;
    }

    return Manasikuna1448LaunchSession(
      profile: profile,
      pack: pack,
      activatedAtUtc: activatedAtUtc,
      credentialExpiresAtUtc: credentialExpiresAtUtc,
      savedAtUtc: savedAtUtc,
    );
  }

  Map<String, dynamic> _profileToJson(OfficialPilgrimSeed profile) {
    return <String, dynamic>{
      'officialReference': profile.officialReference,
      'fullNameAr': profile.fullNameAr,
      'acceptanceStatus': profile.acceptanceStatus.name,
      'sourceAuthority': profile.sourceAuthority,
      'sourceRevision': profile.sourceRevision,
      'effectiveAt': profile.effectiveAt.toUtc().toIso8601String(),
      'campaignReference': profile.campaignReference,
      'groupReference': profile.groupReference,
    };
  }

  OfficialPilgrimSeed? _profileFromJson(Map<String, dynamic> json) {
    final acceptanceStatusName = json['acceptanceStatus'];
    if (acceptanceStatusName is! String) {
      return null;
    }

    OfficialPilgrimAcceptanceStatus? acceptanceStatus;
    for (final candidate in OfficialPilgrimAcceptanceStatus.values) {
      if (candidate.name == acceptanceStatusName) {
        acceptanceStatus = candidate;
        break;
      }
    }
    if (acceptanceStatus == null) {
      return null;
    }

    final effectiveAt = _date(json['effectiveAt']);
    if (effectiveAt == null) {
      return null;
    }

    final officialReference = json['officialReference'];
    final fullNameAr = json['fullNameAr'];
    final sourceAuthority = json['sourceAuthority'];
    final sourceRevision = json['sourceRevision'];
    final campaignReference = json['campaignReference'];
    final groupReference = json['groupReference'];

    if (!_isNonBlankString(officialReference) ||
        !_isNonBlankString(fullNameAr) ||
        !_isNonBlankString(sourceAuthority) ||
        !_isNonBlankString(sourceRevision) ||
        !_isNullableString(campaignReference) ||
        !_isNullableString(groupReference)) {
      return null;
    }

    return OfficialPilgrimSeed(
      officialReference: officialReference as String,
      fullNameAr: fullNameAr as String,
      acceptanceStatus: acceptanceStatus,
      sourceAuthority: sourceAuthority as String,
      sourceRevision: sourceRevision as String,
      effectiveAt: effectiveAt,
      campaignReference: campaignReference as String?,
      groupReference: groupReference as String?,
    );
  }

  Map<String, dynamic> _packToJson(CampaignOperationalPack pack) {
    return <String, dynamic>{
      'packId': pack.packId,
      'schemaVersion': pack.schemaVersion,
      'campaignReference': pack.campaignReference,
      'campaignNameAr': pack.campaignNameAr,
      'updatedAt': pack.updatedAt.toUtc().toIso8601String(),
      'groupReference': pack.groupReference,
      'supervisor':
          pack.supervisor == null ? null : _contactToJson(pack.supervisor!),
      'hotelNameAr': pack.hotelNameAr,
      'hotelAddressAr': pack.hotelAddressAr,
      'transportLabelAr': pack.transportLabelAr,
      'minaCampAr': pack.minaCampAr,
      'arafatCampAr': pack.arafatCampAr,
      'meetingPoints':
          pack.meetingPoints.map(_meetingPointToJson).toList(growable: false),
      'schedule':
          pack.schedule.map(_scheduleItemToJson).toList(growable: false),
      'emergencyContacts':
          pack.emergencyContacts.map(_contactToJson).toList(growable: false),
    };
  }

  CampaignOperationalPack? _packFromJson(Map<String, dynamic> json) {
    final packId = json['packId'];
    final schemaVersion = json['schemaVersion'];
    final campaignReference = json['campaignReference'];
    final campaignNameAr = json['campaignNameAr'];
    final updatedAt = _date(json['updatedAt']);

    if (!_isNonBlankString(packId) ||
        schemaVersion is! int ||
        schemaVersion != supportedPackSchemaVersion ||
        !_isNonBlankString(campaignReference) ||
        !_isNonBlankString(campaignNameAr) ||
        updatedAt == null) {
      return null;
    }

    const optionalStringKeys = <String>[
      'groupReference',
      'hotelNameAr',
      'hotelAddressAr',
      'transportLabelAr',
      'minaCampAr',
      'arafatCampAr',
    ];
    for (final key in optionalStringKeys) {
      if (!_isNullableString(json[key])) {
        return null;
      }
    }

    final meetingPointJson = json['meetingPoints'];
    final scheduleJson = json['schedule'];
    final emergencyJson = json['emergencyContacts'];

    if (meetingPointJson is! List ||
        scheduleJson is! List ||
        emergencyJson is! List) {
      return null;
    }

    final meetingPoints = <CampaignMeetingPoint>[];
    for (final item in meetingPointJson) {
      if (item is! Map) {
        return null;
      }
      final parsed = _meetingPointFromJson(
        Map<String, dynamic>.from(item),
      );
      if (parsed == null) {
        return null;
      }
      meetingPoints.add(parsed);
    }

    final schedule = <CampaignScheduleItem>[];
    for (final item in scheduleJson) {
      if (item is! Map) {
        return null;
      }
      final parsed = _scheduleItemFromJson(
        Map<String, dynamic>.from(item),
      );
      if (parsed == null) {
        return null;
      }
      schedule.add(parsed);
    }

    final emergencyContacts = <OperationalContact>[];
    for (final item in emergencyJson) {
      if (item is! Map) {
        return null;
      }
      final parsed = _contactFromJson(
        Map<String, dynamic>.from(item),
      );
      if (parsed == null) {
        return null;
      }
      emergencyContacts.add(parsed);
    }

    OperationalContact? supervisor;
    final supervisorJson = json['supervisor'];
    if (supervisorJson != null) {
      if (supervisorJson is! Map) {
        return null;
      }
      supervisor = _contactFromJson(
        Map<String, dynamic>.from(supervisorJson),
      );
      if (supervisor == null) {
        return null;
      }
    }

    return CampaignOperationalPack(
      packId: packId as String,
      schemaVersion: schemaVersion as int,
      campaignReference: campaignReference as String,
      campaignNameAr: campaignNameAr as String,
      updatedAt: updatedAt,
      groupReference: json['groupReference'] as String?,
      supervisor: supervisor,
      hotelNameAr: json['hotelNameAr'] as String?,
      hotelAddressAr: json['hotelAddressAr'] as String?,
      transportLabelAr: json['transportLabelAr'] as String?,
      minaCampAr: json['minaCampAr'] as String?,
      arafatCampAr: json['arafatCampAr'] as String?,
      meetingPoints: meetingPoints,
      schedule: schedule,
      emergencyContacts: emergencyContacts,
    );
  }

  Map<String, dynamic> _meetingPointToJson(CampaignMeetingPoint point) {
    return <String, dynamic>{
      'id': point.id,
      'labelAr': point.labelAr,
      'descriptionAr': point.descriptionAr,
      'latitude': point.latitude,
      'longitude': point.longitude,
    };
  }

  CampaignMeetingPoint? _meetingPointFromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final labelAr = json['labelAr'];
    final descriptionAr = json['descriptionAr'];
    final latitude = json['latitude'];
    final longitude = json['longitude'];

    if (!_isNonBlankString(id) ||
        !_isNonBlankString(labelAr) ||
        !_isNonBlankString(descriptionAr) ||
        !_isNullableNumber(latitude) ||
        !_isNullableNumber(longitude)) {
      return null;
    }

    return CampaignMeetingPoint(
      id: id as String,
      labelAr: labelAr as String,
      descriptionAr: descriptionAr as String,
      latitude: latitude == null ? null : (latitude as num).toDouble(),
      longitude: longitude == null ? null : (longitude as num).toDouble(),
    );
  }

  Map<String, dynamic> _scheduleItemToJson(CampaignScheduleItem item) {
    return <String, dynamic>{
      'id': item.id,
      'titleAr': item.titleAr,
      'startsAt': item.startsAt.toUtc().toIso8601String(),
      'endsAt': item.endsAt?.toUtc().toIso8601String(),
      'meetingPointId': item.meetingPointId,
      'notesAr': item.notesAr,
    };
  }

  CampaignScheduleItem? _scheduleItemFromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final titleAr = json['titleAr'];
    final startsAt = _date(json['startsAt']);
    final meetingPointId = json['meetingPointId'];
    final notesAr = json['notesAr'];

    if (!_isNonBlankString(id) ||
        !_isNonBlankString(titleAr) ||
        startsAt == null ||
        !_isNullableString(meetingPointId) ||
        !_isNullableString(notesAr)) {
      return null;
    }

    DateTime? endsAt;
    final rawEndsAt = json['endsAt'];
    if (rawEndsAt != null) {
      endsAt = _date(rawEndsAt);
      if (endsAt == null || !endsAt.isAfter(startsAt)) {
        return null;
      }
    }

    return CampaignScheduleItem(
      id: id as String,
      titleAr: titleAr as String,
      startsAt: startsAt,
      endsAt: endsAt,
      meetingPointId: meetingPointId as String?,
      notesAr: notesAr as String?,
    );
  }

  Map<String, dynamic> _contactToJson(OperationalContact contact) {
    return <String, dynamic>{
      'roleAr': contact.roleAr,
      'nameAr': contact.nameAr,
      'phone': contact.phone,
    };
  }

  OperationalContact? _contactFromJson(Map<String, dynamic> json) {
    final roleAr = json['roleAr'];
    final nameAr = json['nameAr'];
    final phone = json['phone'];

    if (!_isNonBlankString(roleAr) ||
        !_isNonBlankString(nameAr) ||
        !_isNonBlankString(phone)) {
      return null;
    }

    return OperationalContact(
      roleAr: roleAr as String,
      nameAr: nameAr as String,
      phone: phone as String,
    );
  }

  bool _isNonBlankString(Object? value) {
    return value is String && value.trim().isNotEmpty;
  }

  bool _isNullableString(Object? value) {
    return value == null || value is String;
  }

  bool _isNullableNumber(Object? value) {
    return value == null || value is num;
  }

  DateTime? _date(Object? value) {
    if (value is! String || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value)?.toUtc();
  }
}
