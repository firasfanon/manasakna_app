import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/manasikuna_1448_local_store.dart';
import '../data/manasikuna_1448_synthetic_source.dart';
import '../domain/manasikuna_1448_contract_policy.dart';
import '../domain/manasikuna_1448_launch_models.dart';
import '../domain/manasikuna_1448_models.dart';
import '../domain/manasikuna_1448_runtime.dart';

final manasikuna1448LocalStoreProvider =
    Provider<Manasikuna1448LocalStore>((ref) {
  return const Manasikuna1448LocalStore();
});

final manasikuna1448SyntheticSourceProvider =
    Provider<Manasikuna1448SyntheticSource>((ref) {
  return const Manasikuna1448SyntheticSource();
});

final manasikuna1448LaunchControllerProvider = AsyncNotifierProvider<
    Manasikuna1448LaunchController, Manasikuna1448LaunchState>(
  Manasikuna1448LaunchController.new,
);

class Manasikuna1448LaunchController
    extends AsyncNotifier<Manasikuna1448LaunchState> {
  static const _waveCPolicy =
      Manasikuna1448WaveCContractPolicy.syntheticFixturesOnly();

  @override
  Future<Manasikuna1448LaunchState> build() async {
    final store = ref.read(manasikuna1448LocalStoreProvider);
    final session = await store.restore();

    if (session == null) {
      return Manasikuna1448LaunchState.inactive();
    }

    final now = DateTime.now().toUtc();
    if (!session.isCredentialValidAt(now)) {
      await store.clear();
      return Manasikuna1448LaunchState.inactive(
        statusMessageCode: 'offline_activation_expired',
      );
    }

    final profileViolation = _waveCPolicy.profileViolation(
      session.profile,
      now,
    );
    final packViolation = _waveCPolicy.campaignPackViolation(
      profile: session.profile,
      pack: session.pack,
      moment: now,
    );
    if (profileViolation != null || packViolation != null) {
      await store.clear();
      return Manasikuna1448LaunchState.inactive(
        statusMessageCode: 'offline_contract_invalid',
      );
    }

    return Manasikuna1448LaunchState.active(
      session,
      restoredFromOffline: true,
      statusMessageCode: session.isOperationalDataStaleAt(now)
          ? 'offline_snapshot_stale'
          : 'offline_snapshot_restored',
    );
  }

  Future<void> activate(String rawToken) async {
    state = const AsyncLoading<Manasikuna1448LaunchState>();

    state = await AsyncValue.guard(() async {
      final now = DateTime.now().toUtc();
      final source = ref.read(manasikuna1448SyntheticSourceProvider);
      final bundle = source.bundleForToken(rawToken, now: now);

      if (bundle == null) {
        return Manasikuna1448LaunchState.inactive(
          statusMessageCode: 'activation_token_invalid',
        );
      }

      final runtime = Manasikuna1448Runtime(
        standaloneProfileProvider:
            const Manasikuna1448NullStandaloneProfileProvider(),
        campaignProfileProvider: bundle.profileProvider,
        campaignOperationalProvider: bundle.operationalProvider,
        requestedMode: ManasikunaIntegrationMode.campaignConnected,
        waveCContractPolicy: _waveCPolicy,
      );

      final resolved = await runtime.resolve(
        activation: bundle.credential,
        now: now,
      );

      if (resolved.resolution.effectiveMode !=
              ManasikunaIntegrationMode.campaignConnected ||
          resolved.profile == null ||
          resolved.campaignPack == null) {
        return Manasikuna1448LaunchState.inactive(
          statusMessageCode:
              resolved.resolution.fallbackReasonCode ?? 'activation_failed',
        );
      }

      final session = Manasikuna1448LaunchSession(
        profile: resolved.profile!,
        pack: resolved.campaignPack!,
        activatedAtUtc: now,
        credentialExpiresAtUtc: bundle.credential.expiresAt.toUtc(),
        savedAtUtc: now,
      );

      await ref.read(manasikuna1448LocalStoreProvider).save(session);

      return Manasikuna1448LaunchState.active(
        session,
        statusMessageCode: 'activation_success_synthetic',
      );
    });
  }

  Future<void> clearActivation() async {
    state = const AsyncLoading<Manasikuna1448LaunchState>();
    state = await AsyncValue.guard(() async {
      await ref.read(manasikuna1448LocalStoreProvider).clear();
      return Manasikuna1448LaunchState.inactive(
        statusMessageCode: 'activation_cleared',
      );
    });
  }
}
