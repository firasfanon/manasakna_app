import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/manasikuna_1448_launch_models.dart';
import '../domain/manasikuna_1448_models.dart';

class Manasikuna1448LocalStore {
  const Manasikuna1448LocalStore();

  static const String snapshotKey = 'manasikuna_1448_launch_snapshot_v1';

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
      if (decoded is! Map<String, dynamic>) {
        return null;
      }
      return _sessionFromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(snapshotKey);
  }

  Map<String, dynamic> _sessionToJson(
    Manasikuna1448LaunchSession session,
  ) {
    return <String, dynamic>{
      'schemaVersion': 1,
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
    if (json['schemaVersion'] != 1) {
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

    if (officialReference is! String ||
        fullNameAr is! String ||
        sourceAuthority is! String ||
        sourceRevision is! String) {
      return null;
    }

    return OfficialPilgrimSeed(
      officialReference: officialReference,
      fullNameAr: fullNameAr,
      acceptanceStatus: acceptanceStatus,
      sourceAuthority: sourceAuthority,
      sourceRevision: sourceRevision,
      effectiveAt: effectiveAt,
      campaignReference: json['campaignReference'] as String?,
      groupReference: json['groupReference'] as String?,
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

    if (packId is! String ||
        schemaVersion is! int ||
        campaignReference is! String ||
        campaignNameAr is! String ||
        updatedAt == null) {
      return null;
    }

    final meetingPoints = <CampaignMeetingPoint>[];
    final meetingPointJson = json['meetingPoints'];
    if (meetingPointJson is List) {
      for (final item in meetingPointJson) {
        if (item is Map) {
          final parsed = _meetingPointFromJson(
            Map<String, dynamic>.from(item),
          );
          if (parsed != null) {
            meetingPoints.add(parsed);
          }
        }
      }
    }

    final schedule = <CampaignScheduleItem>[];
    final scheduleJson = json['schedule'];
    if (scheduleJson is List) {
      for (final item in scheduleJson) {
        if (item is Map) {
          final parsed = _scheduleItemFromJson(
            Map<String, dynamic>.from(item),
          );
          if (parsed != null) {
            schedule.add(parsed);
          }
        }
      }
    }

    final emergencyContacts = <OperationalContact>[];
    final emergencyJson = json['emergencyContacts'];
    if (emergencyJson is List) {
      for (final item in emergencyJson) {
        if (item is Map) {
          final parsed = _contactFromJson(
            Map<String, dynamic>.from(item),
          );
          if (parsed != null) {
            emergencyContacts.add(parsed);
          }
        }
      }
    }

    OperationalContact? supervisor;
    final supervisorJson = json['supervisor'];
    if (supervisorJson is Map) {
      supervisor = _contactFromJson(
        Map<String, dynamic>.from(supervisorJson),
      );
    }

    return CampaignOperationalPack(
      packId: packId,
      schemaVersion: schemaVersion,
      campaignReference: campaignReference,
      campaignNameAr: campaignNameAr,
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
    if (id is! String || labelAr is! String || descriptionAr is! String) {
      return null;
    }
    return CampaignMeetingPoint(
      id: id,
      labelAr: labelAr,
      descriptionAr: descriptionAr,
      latitude: _double(json['latitude']),
      longitude: _double(json['longitude']),
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
    if (id is! String || titleAr is! String || startsAt == null) {
      return null;
    }

    return CampaignScheduleItem(
      id: id,
      titleAr: titleAr,
      startsAt: startsAt,
      endsAt: _date(json['endsAt']),
      meetingPointId: json['meetingPointId'] as String?,
      notesAr: json['notesAr'] as String?,
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
    if (roleAr is! String || nameAr is! String || phone is! String) {
      return null;
    }
    return OperationalContact(
      roleAr: roleAr,
      nameAr: nameAr,
      phone: phone,
    );
  }

  DateTime? _date(Object? value) {
    if (value is! String || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value)?.toUtc();
  }

  double? _double(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    return null;
  }
}
