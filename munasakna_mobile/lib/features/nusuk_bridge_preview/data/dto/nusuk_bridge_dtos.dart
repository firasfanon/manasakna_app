class NusukPilgrimProfileDto {
  const NusukPilgrimProfileDto({
    required this.pilgrimId,
    required this.displayNameAr,
    required this.nationalIdMasked,
    required this.companyNameAr,
    this.groupNameAr,
  });

  final String pilgrimId;
  final String displayNameAr;
  final String nationalIdMasked;
  final String companyNameAr;
  final String? groupNameAr;

  factory NusukPilgrimProfileDto.fromJson(Map<String, dynamic> json) {
    return NusukPilgrimProfileDto(
      pilgrimId: _requiredString(json, 'pilgrim_id'),
      displayNameAr: _requiredString(json, 'display_name_ar'),
      nationalIdMasked: _requiredString(json, 'national_id_masked'),
      companyNameAr: _requiredString(json, 'company_name_ar'),
      groupNameAr: _optionalString(json, 'group_name_ar'),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'pilgrim_id': pilgrimId,
        'display_name_ar': displayNameAr,
        'national_id_masked': nationalIdMasked,
        'company_name_ar': companyNameAr,
        'group_name_ar': groupNameAr,
      };
}

class NusukJourneyOverviewDto {
  const NusukJourneyOverviewDto({
    required this.seasonId,
    required this.currentStageId,
    required this.readinessScore,
    required this.nextActionAr,
  });

  final String seasonId;
  final String currentStageId;
  final int readinessScore;
  final String nextActionAr;

  factory NusukJourneyOverviewDto.fromJson(Map<String, dynamic> json) {
    final readinessValue = json['readiness_score'];
    if (readinessValue is! num) {
      throw const FormatException('readiness_score must be numeric');
    }

    final readinessScore = readinessValue.toInt();
    if (readinessScore < 0 || readinessScore > 100) {
      throw const FormatException('readiness_score must be between 0 and 100');
    }

    return NusukJourneyOverviewDto(
      seasonId: _requiredString(json, 'season_id'),
      currentStageId: _requiredString(json, 'current_stage_id'),
      readinessScore: readinessScore,
      nextActionAr: _requiredString(json, 'next_action_ar'),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'season_id': seasonId,
        'current_stage_id': currentStageId,
        'readiness_score': readinessScore,
        'next_action_ar': nextActionAr,
      };
}

class NusukContactsDto {
  const NusukContactsDto({
    required this.supervisorPhone,
    required this.emergencyChannels,
    required this.assemblyPoints,
    this.guidePhone,
  });

  final String supervisorPhone;
  final String? guidePhone;
  final List<String> emergencyChannels;
  final List<String> assemblyPoints;

  factory NusukContactsDto.fromJson(Map<String, dynamic> json) {
    return NusukContactsDto(
      supervisorPhone: _requiredString(json, 'supervisor_phone'),
      guidePhone: _optionalString(json, 'guide_phone'),
      emergencyChannels: _stringList(json, 'emergency_channels'),
      assemblyPoints: _stringList(json, 'assembly_points'),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'supervisor_phone': supervisorPhone,
        'guide_phone': guidePhone,
        'emergency_channels': List<String>.from(emergencyChannels),
        'assembly_points': List<String>.from(assemblyPoints),
      };
}

class NusukFeedbackSubmissionDto {
  const NusukFeedbackSubmissionDto({
    required this.feedbackType,
    required this.stageId,
    required this.message,
    required this.auditContext,
  });

  final String feedbackType;
  final String stageId;
  final String message;
  final Map<String, dynamic> auditContext;

  factory NusukFeedbackSubmissionDto.fromJson(Map<String, dynamic> json) {
    return NusukFeedbackSubmissionDto(
      feedbackType: _requiredString(json, 'feedback_type'),
      stageId: _requiredString(json, 'stage_id'),
      message: _requiredString(json, 'message'),
      auditContext: _dynamicMap(json, 'audit_context'),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'feedback_type': feedbackType,
        'stage_id': stageId,
        'message': message,
        'audit_context': Map<String, dynamic>.from(auditContext),
      };
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.trim().isEmpty) {
    throw FormatException('$key must be a non-empty string');
  }
  return value;
}

String? _optionalString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return null;
  }
  if (value is! String) {
    throw FormatException('$key must be a string or null');
  }
  return value;
}

List<String> _stringList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) {
    return const <String>[];
  }
  if (value is! List) {
    throw FormatException('$key must be a list');
  }

  final result = <String>[];
  for (final item in value) {
    if (item is! String) {
      throw FormatException('$key must contain strings only');
    }
    result.add(item);
  }
  return List<String>.unmodifiable(result);
}

Map<String, dynamic> _dynamicMap(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! Map) {
    throw FormatException('$key must be an object');
  }

  final result = <String, dynamic>{};
  for (final entry in value.entries) {
    if (entry.key is! String) {
      throw FormatException('$key keys must be strings');
    }
    result[entry.key as String] = entry.value;
  }
  return Map<String, dynamic>.unmodifiable(result);
}
