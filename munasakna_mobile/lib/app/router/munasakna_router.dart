import 'package:go_router/go_router.dart';

import '../../features/app_guide/presentation/pages/app_guide_page.dart';
import '../../features/beta_readiness/presentation/pages/beta_readiness_page.dart';
import '../../features/beta_review/presentation/pages/beta_review_page.dart';
import '../../features/beta_test_scenarios/presentation/pages/beta_test_scenarios_page.dart';
import '../../features/beta_pilot/presentation/pages/beta_pilot_page.dart';
import '../../features/beta_feedback/presentation/pages/beta_feedback_page.dart';
import '../../features/beta_release/presentation/pages/beta_release_gates_page.dart';
import '../../features/beta_closure/presentation/pages/beta_closure_checklist_page.dart';
import '../../features/store_readiness/presentation/pages/store_readiness_page.dart';
import '../../features/content_approval/presentation/pages/content_approval_queue_page.dart';
import '../../features/quality_risks/presentation/pages/quality_risk_register_page.dart';
import '../../features/nusuk_contracts/presentation/pages/nusuk_contracts_page.dart';
import '../../features/phase_navigator/presentation/pages/phase_navigator_page.dart';
import '../../features/knowledge_governance/presentation/pages/knowledge_governance_page.dart';
import '../../features/nusuk_readiness/presentation/pages/nusuk_readiness_page.dart';
import '../../features/travel_bag/presentation/pages/travel_bag_page.dart';
import '../../features/checklist/presentation/pages/checklist_page.dart';
import '../../features/schedule/presentation/pages/hajj_schedule_page.dart';
import '../../features/documents/presentation/pages/documents_wallet_page.dart';
import '../../features/group/presentation/pages/group_supervisor_page.dart';
import '../../features/accommodation_transport/presentation/pages/accommodation_transport_page.dart';
import '../../features/accessibility/presentation/pages/accessibility_support_page.dart';
import '../../features/post_hajj/presentation/pages/post_hajj_page.dart';
import '../../features/complaints/presentation/pages/complaints_page.dart';
import '../../features/contacts/presentation/pages/contacts_page.dart';
import '../../features/digital_card/presentation/pages/digital_card_page.dart';
import '../../features/daily_companion/presentation/pages/daily_companion_page.dart';
import '../../features/field_guide/presentation/pages/field_guide_page.dart';
import '../../features/emergency/presentation/pages/emergency_page.dart';
import '../../features/fatwa/presentation/pages/fatwa_page.dart';
import '../../features/guidance/presentation/pages/guidance_page.dart';
import '../../features/hajj_assistant/presentation/pages/simple_hajj_assistant_page.dart';
import '../../features/hajj_faq/presentation/pages/contextual_faq_page.dart';
import '../../features/hajj_type/presentation/pages/hajj_type_page.dart';
import '../../features/hajj_matrix/presentation/pages/hajj_matrix_page.dart';
import '../../features/hajj_matrix/presentation/pages/layered_guide_page.dart';
import '../../features/health/presentation/pages/health_page.dart';
import '../../features/home/presentation/pages/munasakna_home_page.dart';
import '../../features/journey/presentation/pages/journey_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/miqat/presentation/pages/miqat_page.dart';
import '../../features/location/presentation/pages/current_location_page.dart';
import '../../features/prayer_times/presentation/pages/prayer_times_page.dart';
import '../../features/offline_library/presentation/pages/offline_library_page.dart';
import '../../features/privacy/presentation/pages/privacy_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/update_profile_page.dart';
import '../../features/rituals/presentation/pages/rituals_page.dart';
import '../../features/services/presentation/pages/services_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/survey/presentation/pages/survey_page.dart';
import '../../features/useful_links/presentation/pages/useful_links_page.dart';
import '../../features/ui_consistency/presentation/pages/ui_consistency_sweep_page.dart';
import '../../features/assistant_safety/presentation/pages/assistant_safety_hardening_page.dart';
import '../../features/faq_expansion/presentation/pages/faq_expansion_approval_page.dart';
import '../../features/nusuk_bridge_mock/presentation/pages/nusuk_bridge_mock_page.dart';
import '../../features/stage_reminders/presentation/pages/stage_reminders_page.dart';
import '../../features/platform_readiness/presentation/pages/platform_readiness_page.dart';
import '../../features/final_beta_smoke/presentation/pages/final_beta_smoke_page.dart';
import '../../features/beta_content_audit/presentation/pages/beta_content_ux_audit_page.dart';
import '../../features/nusuk_integration_handoff/presentation/pages/nusuk_integration_handoff_page.dart';
import 'munasakna_routes.dart';

final GoRouter munasaknaRouter = GoRouter(
  initialLocation: MunasaknaRoutes.home,
  routes: [
    GoRoute(path: MunasaknaRoutes.home, builder: (context, state) => const MunasaknaHomePage()),
    GoRoute(path: MunasaknaRoutes.profile, builder: (context, state) => const ProfilePage()),
    GoRoute(path: MunasaknaRoutes.updateProfile, builder: (context, state) => const UpdateProfilePage()),
    GoRoute(path: MunasaknaRoutes.journey, builder: (context, state) => const JourneyPage()),
    GoRoute(path: MunasaknaRoutes.rituals, builder: (context, state) => const RitualsPage()),
    GoRoute(path: MunasaknaRoutes.checklist, builder: (context, state) => const ChecklistPage()),
    GoRoute(path: MunasaknaRoutes.guidance, builder: (context, state) => const GuidancePage()),
    GoRoute(path: MunasaknaRoutes.fatwa, builder: (context, state) => const FatwaPage()),
    GoRoute(path: MunasaknaRoutes.complaints, builder: (context, state) => const ComplaintsPage()),
    GoRoute(path: MunasaknaRoutes.survey, builder: (context, state) => const SurveyPage()),
    GoRoute(path: MunasaknaRoutes.contacts, builder: (context, state) => const ContactsPage()),
    GoRoute(path: MunasaknaRoutes.prayerTimes, builder: (context, state) => const PrayerTimesPage()),
    GoRoute(path: MunasaknaRoutes.usefulLinks, builder: (context, state) => const UsefulLinksPage()),
    GoRoute(path: MunasaknaRoutes.currentLocation, builder: (context, state) => const CurrentLocationPage()),
    GoRoute(path: MunasaknaRoutes.health, builder: (context, state) => const HealthPage()),
    GoRoute(path: MunasaknaRoutes.emergency, builder: (context, state) => const EmergencyPage()),
    GoRoute(path: MunasaknaRoutes.digitalCard, builder: (context, state) => const DigitalCardPage()),
    GoRoute(path: MunasaknaRoutes.services, builder: (context, state) => const ServicesPage()),
    GoRoute(path: MunasaknaRoutes.settings, builder: (context, state) => const SettingsPage()),
    GoRoute(path: MunasaknaRoutes.privacy, builder: (context, state) => const PrivacyPage()),
    GoRoute(path: MunasaknaRoutes.notifications, builder: (context, state) => const NotificationsPage()),
    GoRoute(path: MunasaknaRoutes.hajjMatrix, builder: (context, state) => const HajjMatrixPage()),
    GoRoute(path: MunasaknaRoutes.layerGuide, builder: (context, state) => const LayeredGuidePage()),
    GoRoute(path: MunasaknaRoutes.hajjFaq, builder: (context, state) => const ContextualFaqPage()),
    GoRoute(path: MunasaknaRoutes.hajjAssistant, builder: (context, state) => const SimpleHajjAssistantPage()),
    GoRoute(path: MunasaknaRoutes.hajjType, builder: (context, state) => const HajjTypePage()),
    GoRoute(path: MunasaknaRoutes.miqat, builder: (context, state) => const MiqatPage()),
    GoRoute(path: MunasaknaRoutes.dailyCompanion, builder: (context, state) => const DailyCompanionPage()),
    GoRoute(path: MunasaknaRoutes.fieldGuide, builder: (context, state) => const FieldGuidePage()),
    GoRoute(path: MunasaknaRoutes.offlineLibrary, builder: (context, state) => const OfflineLibraryPage()),
    GoRoute(path: MunasaknaRoutes.hajjSchedule, builder: (context, state) => const HajjSchedulePage()),
    GoRoute(path: MunasaknaRoutes.documentsWallet, builder: (context, state) => const DocumentsWalletPage()),
    GoRoute(path: MunasaknaRoutes.groupSupervisor, builder: (context, state) => const GroupSupervisorPage()),
    GoRoute(path: MunasaknaRoutes.accommodationTransport, builder: (context, state) => const AccommodationTransportPage()),
    GoRoute(path: MunasaknaRoutes.accessibilitySupport, builder: (context, state) => const AccessibilitySupportPage()),
    GoRoute(path: MunasaknaRoutes.postHajj, builder: (context, state) => const PostHajjPage()),
    GoRoute(path: MunasaknaRoutes.appGuide, builder: (context, state) => const AppGuidePage()),
    GoRoute(path: MunasaknaRoutes.phaseNavigator, builder: (context, state) => const PhaseNavigatorPage()),
    GoRoute(path: MunasaknaRoutes.knowledgeGovernance, builder: (context, state) => const KnowledgeGovernancePage()),
    GoRoute(path: MunasaknaRoutes.nusukReadiness, builder: (context, state) => const NusukReadinessPage()),
    GoRoute(path: MunasaknaRoutes.travelBag, builder: (context, state) => const TravelBagPage()),
    GoRoute(path: MunasaknaRoutes.betaReadiness, builder: (context, state) => const BetaReadinessPage()),
    GoRoute(path: MunasaknaRoutes.betaReview, builder: (context, state) => const BetaReviewPage()),
    GoRoute(path: MunasaknaRoutes.betaTestScenarios, builder: (context, state) => const BetaTestScenariosPage()),
    GoRoute(path: MunasaknaRoutes.nusukContracts, builder: (context, state) => const NusukContractsPage()),
    GoRoute(path: MunasaknaRoutes.betaPilot, builder: (context, state) => const BetaPilotPage()),
    GoRoute(path: MunasaknaRoutes.betaFeedback, builder: (context, state) => const BetaFeedbackPage()),
    GoRoute(path: MunasaknaRoutes.releaseGates, builder: (context, state) => const BetaReleaseGatesPage()),
    GoRoute(path: MunasaknaRoutes.betaClosureChecklist, builder: (context, state) => const BetaClosureChecklistPage()),
    GoRoute(path: MunasaknaRoutes.storeReadiness, builder: (context, state) => const StoreReadinessPage()),
    GoRoute(path: MunasaknaRoutes.contentApprovalQueue, builder: (context, state) => const ContentApprovalQueuePage()),
    GoRoute(path: MunasaknaRoutes.qualityRiskRegister, builder: (context, state) => const QualityRiskRegisterPage()),
    GoRoute(path: MunasaknaRoutes.uiConsistencySweep, builder: (context, state) => const UiConsistencySweepPage()),
    GoRoute(path: MunasaknaRoutes.assistantSafetyHardening, builder: (context, state) => const AssistantSafetyHardeningPage()),
    GoRoute(path: MunasaknaRoutes.faqExpansionApproval, builder: (context, state) => const FaqExpansionApprovalPage()),
    GoRoute(path: MunasaknaRoutes.nusukBridgeMock, builder: (context, state) => const NusukBridgeMockPage()),
    GoRoute(path: MunasaknaRoutes.stageReminders, builder: (context, state) => const StageRemindersPage()),
    GoRoute(path: MunasaknaRoutes.platformReadiness, builder: (context, state) => const PlatformReadinessPage()),
    GoRoute(path: MunasaknaRoutes.finalBetaSmoke, builder: (context, state) => const FinalBetaSmokePage()),
    GoRoute(path: MunasaknaRoutes.betaContentUxAudit, builder: (context, state) => const BetaContentUxAuditPage()),
    GoRoute(path: MunasaknaRoutes.nusukIntegrationHandoff, builder: (context, state) => const NusukIntegrationHandoffPage()),
  ],
);
