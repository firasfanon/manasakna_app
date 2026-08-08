import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/demo_nusuk_repository.dart';
import '../../domain/models/journey_overview.dart';
import '../../domain/models/journey_step.dart';
import '../../domain/models/pilgrim_profile.dart';
import '../../domain/repositories/nusuk_repository.dart';

final nusukRepositoryProvider = Provider<NusukRepository>((ref) {
  return const DemoNusukRepository();
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
