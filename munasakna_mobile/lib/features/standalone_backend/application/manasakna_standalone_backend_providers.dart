import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/manasakna_standalone_backend_client.dart';
import '../domain/manasakna_standalone_backend_models.dart';

final manasaknaStandaloneBackendProvider =
    Provider<ManasaknaStandaloneBackendGateway>((ref) {
  return HttpManasaknaStandaloneBackendClient(
    config: ManasaknaStandaloneBackendConfig.fromEnvironment(),
  );
});

final manasaknaCurrentSeasonProvider =
    FutureProvider<ManasaknaStandaloneSeason?>((ref) async {
  final backend = ref.watch(manasaknaStandaloneBackendProvider);
  if (!backend.isConfigured) return null;
  return backend.loadCurrentSeason();
});

Future<List<ManasaknaPublishedContent>> _content(
  Ref ref,
  String type,
) async {
  final backend = ref.watch(manasaknaStandaloneBackendProvider);
  if (!backend.isConfigured) return const <ManasaknaPublishedContent>[];
  final season = await ref.watch(manasaknaCurrentSeasonProvider.future);
  return backend.loadContent(
    contentType: type,
    seasonCode: season?.seasonCode,
  );
}

final manasaknaGuidanceContentProvider =
    FutureProvider<List<ManasaknaPublishedContent>>(
        (ref) => _content(ref, 'guidance'));

final manasaknaFatwaContentProvider =
    FutureProvider<List<ManasaknaPublishedContent>>(
        (ref) => _content(ref, 'fatwa'));

final manasaknaServiceContentProvider =
    FutureProvider<List<ManasaknaPublishedContent>>(
        (ref) => _content(ref, 'service'));

final manasaknaNotificationsProvider =
    FutureProvider<List<ManasaknaPublishedNotification>>((ref) async {
  final backend = ref.watch(manasaknaStandaloneBackendProvider);
  if (!backend.isConfigured) return const <ManasaknaPublishedNotification>[];
  final season = await ref.watch(manasaknaCurrentSeasonProvider.future);
  return backend.loadNotifications(seasonCode: season?.seasonCode);
});
