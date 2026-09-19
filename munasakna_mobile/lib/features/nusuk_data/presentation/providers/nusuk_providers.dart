import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../journey_contract/data/synthetic_journey_context_provider.dart';
import '../../../journey_contract/domain/journey_context.dart';
import '../../../journey_contract/domain/journey_context_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../data/demo_nusuk_repository.dart';
import '../../domain/models/journey_overview.dart';
import '../../domain/models/journey_step.dart';
import '../../domain/models/pilgrim_profile.dart';
import '../../domain/repositories/nusuk_repository.dart';

final nusukRepositoryProvider = Provider<NusukRepository>((ref) {
  final settings = ref.watch(appSettingsControllerProvider).value;
  final ritualPath = settings?.preferredRitualPath ?? 'hajj';
  return DemoNusukRepository(ritualPath: ritualPath);
});

final journeyContextProvider = FutureProvider<JourneyContext>((ref) async {
  final settings = ref.watch(appSettingsControllerProvider).value;
  final ritualPath = settings?.preferredRitualPath ?? 'hajj';
  final journeyType =
      ritualPath == 'umrah' ? JourneyType.umrah : JourneyType.hajj;
  return JourneyContextGateway(
    SyntheticJourneyContextProvider(type: journeyType),
  ).load();
});

final pilgrimProfileProvider = FutureProvider<PilgrimProfile>((ref) async {
  return ref.watch(nusukRepositoryProvider).getMyProfile();
});

final journeyOverviewProvider = FutureProvider<JourneyOverview>((ref) async {
  return ref.watch(nusukRepositoryProvider).getJourneyOverview();
});

final journeyStepsProvider = FutureProvider<List<JourneyStep>>((ref) async {
  return ref.watch(nusukRepositoryProvider).getJourneySteps();
});

final guidanceItemsProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(nusukRepositoryProvider).getGuidanceItems();
});

final fatwaItemsProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(nusukRepositoryProvider).getFatwaItems();
});

final contactsProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(nusukRepositoryProvider).getImportantContacts();
});

final usefulLinksProvider = FutureProvider<List<String>>((ref) async {
  return ref.watch(nusukRepositoryProvider).getUsefulLinks();
});
