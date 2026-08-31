import '../dto/nusuk_bridge_dtos.dart';
import '../../domain/models/nusuk_bridge_runtime_models.dart';

abstract interface class NusukLocalPreviewDataSource {
  Future<NusukPilgrimProfileDto> getPilgrimProfile();

  Future<NusukJourneyOverviewDto> getJourneyOverview();

  Future<NusukContactsDto> getContacts();

  Future<void> saveFeedbackDraft(NusukFeedbackSubmissionDto submission);
}

abstract interface class NusukRemoteDataSource {
  Future<NusukPilgrimProfileDto> getPilgrimProfile();

  Future<NusukJourneyOverviewDto> getJourneyOverview();

  Future<NusukContactsDto> getContacts();

  Future<void> submitFeedback(NusukFeedbackSubmissionDto submission);
}

abstract interface class NusukBridgeRepository {
  NusukBridgeFeatureMode get mode;

  Future<NusukPilgrimProfileDto> getPilgrimProfile();

  Future<NusukJourneyOverviewDto> getJourneyOverview();

  Future<NusukContactsDto> getContacts();

  Future<void> saveFeedbackDraft(NusukFeedbackSubmissionDto submission);

  Future<void> submitFeedback(NusukFeedbackSubmissionDto submission);
}
