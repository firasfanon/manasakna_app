import 'manasikuna_1448_models.dart';

class Manasikuna1448LaunchSession {
  const Manasikuna1448LaunchSession({
    required this.profile,
    required this.pack,
    required this.activatedAtUtc,
    required this.credentialExpiresAtUtc,
    required this.savedAtUtc,
  });

  final OfficialPilgrimSeed profile;
  final CampaignOperationalPack pack;
  final DateTime activatedAtUtc;
  final DateTime credentialExpiresAtUtc;
  final DateTime savedAtUtc;

  bool isCredentialValidAt(DateTime moment) {
    final utc = moment.toUtc();
    return utc.isBefore(credentialExpiresAtUtc.toUtc());
  }

  bool isOperationalDataStaleAt(
    DateTime moment, {
    Duration staleAfter = const Duration(hours: 24),
  }) {
    final age = moment.toUtc().difference(pack.updatedAt.toUtc());
    return age > staleAfter;
  }

  CampaignScheduleItem? nextScheduleItem(DateTime moment) {
    final now = moment.toUtc();
    final candidates = pack.schedule
        .where((item) => item.startsAt.toUtc().isAfter(now))
        .toList(growable: false)
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));

    if (candidates.isEmpty) {
      return null;
    }
    return candidates.first;
  }
}

class Manasikuna1448LaunchState {
  const Manasikuna1448LaunchState({
    this.session,
    this.restoredFromOffline = false,
    this.statusMessageCode,
  });

  final Manasikuna1448LaunchSession? session;
  final bool restoredFromOffline;
  final String? statusMessageCode;

  bool get isActive => session != null;

  factory Manasikuna1448LaunchState.inactive({
    String? statusMessageCode,
  }) {
    return Manasikuna1448LaunchState(
      statusMessageCode: statusMessageCode,
    );
  }

  factory Manasikuna1448LaunchState.active(
    Manasikuna1448LaunchSession session, {
    bool restoredFromOffline = false,
    String? statusMessageCode,
  }) {
    return Manasikuna1448LaunchState(
      session: session,
      restoredFromOffline: restoredFromOffline,
      statusMessageCode: statusMessageCode,
    );
  }
}
