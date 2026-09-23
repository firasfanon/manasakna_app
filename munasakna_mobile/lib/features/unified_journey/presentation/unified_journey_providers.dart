import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../journey_contract/domain/journey_context.dart';
import '../../settings/domain/models/munasakna_app_settings.dart';
import '../../settings/presentation/providers/settings_provider.dart';
import '../data/phase8_journey_catalog.dart';
import '../domain/unified_journey_resolution.dart';

final phase8JourneyCatalogProvider = Provider<Phase8JourneyCatalog>((ref) {
  return const LocalPhase8JourneyCatalog();
});

final unifiedJourneyResolutionProvider =
    FutureProvider<UnifiedJourneyResolution>((ref) async {
  final settingsState = ref.watch(appSettingsControllerProvider);
  final settings = settingsState.value ?? MunasaknaAppSettings.defaults;
  final preferredType = switch (settings.preferredRitualPath) {
    'hajj' => JourneyType.hajj,
    'umrah' => JourneyType.umrah,
    _ => null,
  };

  final catalog = ref.watch(phase8JourneyCatalogProvider);
  final contexts = await catalog.loadEligibleJourneys();

  return const UnifiedJourneyResolver().resolve(
    contexts,
    preferredType: preferredType,
  );
});

Future<void> selectUnifiedJourney(
  WidgetRef ref,
  JourneyType type,
) async {
  await ref
      .read(appSettingsControllerProvider.notifier)
      .setPreferredRitualPath(type.name);
  ref.invalidate(unifiedJourneyResolutionProvider);
}
