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
    const source = Manasikuna1448SyntheticSource();
    const store = Manasikuna1448LocalStore();
    final now = DateTime.utc(2026, 9, 2, 12);
    final bundle = source.bundleForToken(
      Manasikuna1448SyntheticSource.demoToken,
      now: now,
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
      now: now,
    );

    final session = Manasikuna1448LaunchSession(
      profile: resolved.profile!,
      pack: resolved.campaignPack!,
      activatedAtUtc: now,
      credentialExpiresAtUtc: bundle.credential.expiresAt,
      savedAtUtc: now,
    );

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
        restored!.profile.officialReference, session.profile.officialReference);
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
}
