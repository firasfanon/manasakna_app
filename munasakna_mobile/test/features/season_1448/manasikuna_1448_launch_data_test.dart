import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/features/season_1448/application/manasikuna_1448_launch_controller.dart';
import 'package:munasakna_mobile/features/season_1448/data/manasikuna_1448_local_store.dart';
import 'package:munasakna_mobile/features/season_1448/data/manasikuna_1448_synthetic_source.dart';
import 'package:munasakna_mobile/features/season_1448/domain/manasikuna_1448_launch_models.dart';
import 'package:munasakna_mobile/features/season_1448/domain/manasikuna_1448_models.dart';
import 'package:munasakna_mobile/features/season_1448/domain/manasikuna_1448_runtime.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('synthetic activation rejects unknown token', () {
    const source = Manasikuna1448SyntheticSource();
    final bundle = source.bundleForToken(
      'UNKNOWN-TOKEN',
      now: DateTime.utc(2026, 9, 2, 12),
    );

    expect(bundle, isNull);
  });

  test('synthetic activation rejects blank token', () {
    const source = Manasikuna1448SyntheticSource();
    final bundle = source.bundleForToken(
      '   ',
      now: DateTime.utc(2026, 9, 2, 12),
    );

    expect(bundle, isNull);
  });

  test('synthetic activation resolves through campaign runtime', () async {
    const source = Manasikuna1448SyntheticSource();
    final now = DateTime.utc(2026, 9, 2, 12);
    final bundle = source.bundleForToken(
      Manasikuna1448SyntheticSource.demoToken,
      now: now,
    );

    expect(bundle, isNotNull);

    final runtime = Manasikuna1448Runtime(
      standaloneProfileProvider:
          const Manasikuna1448NullStandaloneProfileProvider(),
      campaignProfileProvider: bundle!.profileProvider,
      campaignOperationalProvider: bundle.operationalProvider,
      requestedMode: ManasikunaIntegrationMode.campaignConnected,
    );

    final result = await runtime.resolve(
      activation: bundle.credential,
      now: now,
    );

    expect(
      result.resolution.effectiveMode,
      ManasikunaIntegrationMode.campaignConnected,
    );
    expect(result.profile?.isActivationEligible, isTrue);
    expect(
      result.campaignPack?.packId,
      Manasikuna1448SyntheticSource.syntheticPackId,
    );
    expect(result.campaignPack?.schedule, isNotEmpty);
    expect(result.campaignPack?.meetingPoints, isNotEmpty);
  });

  test('offline store round-trip never persists activation token', () async {
    const store = Manasikuna1448LocalStore();
    final session = await _validSession();

    await store.save(session);

    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(Manasikuna1448LocalStore.snapshotKey);

    expect(raw, isNotNull);
    expect(
      raw,
      isNot(contains(Manasikuna1448SyntheticSource.demoToken)),
    );

    final restored = await store.restore();
    expect(restored, isNotNull);
    expect(
      restored!.profile.officialReference,
      session.profile.officialReference,
    );
    expect(restored.pack.packId, session.pack.packId);
    expect(restored.pack.schedule.length, session.pack.schedule.length);
  });

  test('controller activates and a new container restores offline state',
      () async {
    final first = ProviderContainer();

    final initial =
        await first.read(manasikuna1448LaunchControllerProvider.future);
    expect(initial.isActive, isFalse);

    await first
        .read(manasikuna1448LaunchControllerProvider.notifier)
        .activate(Manasikuna1448SyntheticSource.demoToken);

    final activated =
        await first.read(manasikuna1448LaunchControllerProvider.future);
    expect(activated.isActive, isTrue);
    expect(activated.restoredFromOffline, isFalse);

    first.dispose();

    final second = ProviderContainer();
    addTearDown(second.dispose);

    final restored =
        await second.read(manasikuna1448LaunchControllerProvider.future);

    expect(restored.isActive, isTrue);
    expect(restored.restoredFromOffline, isTrue);
    expect(restored.session?.pack.campaignNameAr, contains('تجريبية'));
  });

  for (final status in <String>['waitlisted', 'cancelled']) {
    test('offline restore rejects $status profile and clears snapshot',
        () async {
      const store = Manasikuna1448LocalStore();
      await store.save(await _validSession());

      await _mutateSnapshot((snapshot) {
        final profile = snapshot['profile'] as Map<String, dynamic>;
        profile['acceptanceStatus'] = status;
      });

      expect(await store.restore(), isNull);
      await _expectSnapshotCleared();
    });
  }

  test('offline restore rejects campaign mismatch and clears snapshot',
      () async {
    const store = Manasikuna1448LocalStore();
    await store.save(await _validSession());

    await _mutateSnapshot((snapshot) {
      final pack = snapshot['pack'] as Map<String, dynamic>;
      pack['campaignReference'] = 'campaign-other';
    });

    expect(await store.restore(), isNull);
    await _expectSnapshotCleared();
  });

  test('offline restore rejects group mismatch and clears snapshot', () async {
    const store = Manasikuna1448LocalStore();
    await store.save(await _validSession());

    await _mutateSnapshot((snapshot) {
      final pack = snapshot['pack'] as Map<String, dynamic>;
      pack['groupReference'] = 'group-other';
    });

    expect(await store.restore(), isNull);
    await _expectSnapshotCleared();
  });

  test('offline restore rejects unsupported pack schema and clears snapshot',
      () async {
    const store = Manasikuna1448LocalStore();
    await store.save(await _validSession());

    await _mutateSnapshot((snapshot) {
      final pack = snapshot['pack'] as Map<String, dynamic>;
      pack['schemaVersion'] = 2;
    });

    expect(await store.restore(), isNull);
    await _expectSnapshotCleared();
  });

  for (final key in <String>[
    'meetingPoints',
    'schedule',
    'emergencyContacts',
  ]) {
    test('offline restore rejects malformed $key collection', () async {
      const store = Manasikuna1448LocalStore();
      await store.save(await _validSession());

      await _mutateSnapshot((snapshot) {
        final pack = snapshot['pack'] as Map<String, dynamic>;
        pack[key] = <String, Object>{'corrupt': true};
      });

      expect(await store.restore(), isNull);
      await _expectSnapshotCleared();
    });
  }

  test('offline restore rejects malformed required collection item', () async {
    const store = Manasikuna1448LocalStore();
    await store.save(await _validSession());

    await _mutateSnapshot((snapshot) {
      final pack = snapshot['pack'] as Map<String, dynamic>;
      pack['schedule'] = <Object>[
        <String, Object>{'id': 'broken-item'},
      ];
    });

    expect(await store.restore(), isNull);
    await _expectSnapshotCleared();
  });

  test('controller reports stale restored snapshot explicitly', () async {
    final now = DateTime.now().toUtc();
    const store = Manasikuna1448LocalStore();
    await store.save(await _validSession(now: now));

    await _mutateSnapshot((snapshot) {
      final pack = snapshot['pack'] as Map<String, dynamic>;
      pack['updatedAt'] =
          now.subtract(const Duration(hours: 25)).toIso8601String();
    });

    final container = ProviderContainer();
    addTearDown(container.dispose);

    final restored =
        await container.read(manasikuna1448LaunchControllerProvider.future);

    expect(restored.isActive, isTrue);
    expect(restored.restoredFromOffline, isTrue);
    expect(restored.statusMessageCode, 'offline_snapshot_stale');
  });
}

Future<Manasikuna1448LaunchSession> _validSession({
  DateTime? now,
}) async {
  const source = Manasikuna1448SyntheticSource();
  final clock = (now ?? DateTime.now()).toUtc();
  final bundle = source.bundleForToken(
    Manasikuna1448SyntheticSource.demoToken,
    now: clock,
  )!;

  final runtime = Manasikuna1448Runtime(
    standaloneProfileProvider:
        const Manasikuna1448NullStandaloneProfileProvider(),
    campaignProfileProvider: bundle.profileProvider,
    campaignOperationalProvider: bundle.operationalProvider,
    requestedMode: ManasikunaIntegrationMode.campaignConnected,
  );

  final resolved = await runtime.resolve(
    activation: bundle.credential,
    now: clock,
  );

  return Manasikuna1448LaunchSession(
    profile: resolved.profile!,
    pack: resolved.campaignPack!,
    activatedAtUtc: clock,
    credentialExpiresAtUtc: bundle.credential.expiresAt,
    savedAtUtc: clock,
  );
}

Future<void> _mutateSnapshot(
  void Function(Map<String, dynamic> snapshot) mutation,
) async {
  final preferences = await SharedPreferences.getInstance();
  final raw = preferences.getString(Manasikuna1448LocalStore.snapshotKey);
  if (raw == null) {
    throw StateError('Expected a stored snapshot.');
  }

  final decoded = jsonDecode(raw);
  if (decoded is! Map) {
    throw StateError('Expected a JSON object snapshot.');
  }

  final snapshot = Map<String, dynamic>.from(decoded);
  mutation(snapshot);

  await preferences.setString(
    Manasikuna1448LocalStore.snapshotKey,
    jsonEncode(snapshot),
  );
}

Future<void> _expectSnapshotCleared() async {
  final preferences = await SharedPreferences.getInstance();
  expect(
    preferences.containsKey(Manasikuna1448LocalStore.snapshotKey),
    isFalse,
  );
}
