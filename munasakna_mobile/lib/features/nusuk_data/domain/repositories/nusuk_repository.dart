import '../models/journey_overview.dart';
import '../models/journey_step.dart';
import '../models/pilgrim_profile.dart';

abstract class NusukRepository {
  Future<PilgrimProfile> getMyProfile();
  Future<JourneyOverview> getJourneyOverview();
  Future<List<JourneyStep>> getJourneySteps();
  Future<List<String>> getGuidanceItems();
  Future<List<String>> getFatwaItems();
  Future<List<String>> getImportantContacts();
  Future<List<String>> getUsefulLinks();
}
