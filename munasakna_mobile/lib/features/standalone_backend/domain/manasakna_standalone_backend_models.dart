import '../../season_1448/domain/manasikuna_1448_models.dart';

class ManasaknaStandaloneSeason {
  const ManasaknaStandaloneSeason({
    required this.seasonCode,
    required this.titleAr,
    required this.status,
    this.hijriYear,
    this.gregorianYear,
    this.settings = const <String, dynamic>{},
  });

  final String seasonCode;
  final String titleAr;
  final String status;
  final int? hijriYear;
  final int? gregorianYear;
  final Map<String, dynamic> settings;
}

class ManasaknaPublishedContent {
  const ManasaknaPublishedContent({
    required this.contentType,
    required this.slug,
    required this.titleAr,
    required this.bodyAr,
    required this.metadata,
    this.publishedAt,
  });

  final String contentType;
  final String slug;
  final String titleAr;
  final String bodyAr;
  final Map<String, dynamic> metadata;
  final DateTime? publishedAt;
}

class ManasaknaPublishedNotification {
  const ManasaknaPublishedNotification({
    required this.id,
    required this.titleAr,
    required this.bodyAr,
    required this.audience,
    this.publishedAt,
  });

  final String id;
  final String titleAr;
  final String bodyAr;
  final Map<String, dynamic> audience;
  final DateTime? publishedAt;
}

class ManasaknaBackendActivationContext {
  const ManasaknaBackendActivationContext({
    required this.profile,
    required this.pack,
    required this.sessionToken,
    required this.sessionExpiresAt,
    required this.season,
  });

  final OfficialPilgrimSeed profile;
  final CampaignOperationalPack pack;
  final String sessionToken;
  final DateTime sessionExpiresAt;
  final ManasaknaStandaloneSeason season;
}
