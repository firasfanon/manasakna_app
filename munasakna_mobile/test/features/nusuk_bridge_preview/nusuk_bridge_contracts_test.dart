import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/features/nusuk_bridge_preview/data/contracts/nusuk_bridge_contracts.dart';
import 'package:munasakna_mobile/features/nusuk_bridge_preview/data/dto/nusuk_bridge_dtos.dart';
import 'package:munasakna_mobile/features/nusuk_bridge_preview/data/nusuk_bridge_preview_registry.dart';
import 'package:munasakna_mobile/features/nusuk_bridge_preview/domain/models/nusuk_bridge_runtime_models.dart';

void main() {
  group('Nusuk DTO contracts', () {
    test('pilgrim profile maps registry-shaped JSON both directions', () {
      final json = <String, dynamic>{
        'pilgrim_id': 'demo-local-pilgrim',
        'display_name_ar': 'حاج / معتمر',
        'national_id_masked': '******1234',
        'company_name_ar': 'حملة السفر',
        'group_name_ar': 'المجموعة الأساسية',
      };

      final dto = NusukPilgrimProfileDto.fromJson(json);

      expect(dto.pilgrimId, 'demo-local-pilgrim');
      expect(dto.displayNameAr, 'حاج / معتمر');
      expect(dto.nationalIdMasked, '******1234');
      expect(dto.companyNameAr, 'حملة السفر');
      expect(dto.groupNameAr, 'المجموعة الأساسية');
      expect(dto.toJson(), json);
    });

    test('journey overview enforces readiness range', () {
      final dto = NusukJourneyOverviewDto.fromJson(<String, dynamic>{
        'season_id': '1447H',
        'current_stage_id': 'documents_health',
        'readiness_score': 65,
        'next_action_ar': 'راجع الجواز والتطعيم ونقطة التجمع',
      });

      expect(dto.readinessScore, 65);
      expect(dto.toJson()['current_stage_id'], 'documents_health');

      expect(
        () => NusukJourneyOverviewDto.fromJson(<String, dynamic>{
          'season_id': '1447H',
          'current_stage_id': 'documents_health',
          'readiness_score': 101,
          'next_action_ar': 'اختبار',
        }),
        throwsFormatException,
      );
    });

    test('contacts preserve string lists and optional guide phone', () {
      final dto = NusukContactsDto.fromJson(<String, dynamic>{
        'supervisor_phone': '+000000000',
        'guide_phone': '+000000001',
        'emergency_channels': <String>['الطوارئ', 'الدعم الميداني'],
        'assembly_points': <String>['نقطة تجمع تجريبية'],
      });

      expect(dto.supervisorPhone, '+000000000');
      expect(dto.guidePhone, '+000000001');
      expect(dto.emergencyChannels, <String>['الطوارئ', 'الدعم الميداني']);
      expect(dto.assemblyPoints, <String>['نقطة تجمع تجريبية']);
    });

    test('feedback preserves audit context without enabling transport', () {
      final dto = NusukFeedbackSubmissionDto.fromJson(<String, dynamic>{
        'feedback_type': 'complaint',
        'stage_id': 'accommodation_transport',
        'message': 'نص الشكوى بعد فلترة الحقول',
        'audit_context': <String, dynamic>{
          'source': 'munasakna',
          'mode': 'preview',
        },
      });

      expect(dto.feedbackType, 'complaint');
      expect(dto.stageId, 'accommodation_transport');
      expect(dto.auditContext['mode'], 'preview');
      expect(dto.toJson()['message'], 'نص الشكوى بعد فلترة الحقول');
    });
  });

  group('Nusuk preview runtime contract', () {
    test('feature modes remain explicit and non-ambiguous', () {
      expect(
        NusukBridgeFeatureMode.guestDevelopment.isGuestDevelopment,
        isTrue,
      );
      expect(
        NusukBridgeFeatureMode.guestDevelopment.expectsAuthenticatedIdentity,
        isFalse,
      );
      expect(
        NusukBridgeFeatureMode.nusukConnectedPreview.isConnectedPreview,
        isTrue,
      );
      expect(
        NusukBridgeFeatureMode.productionConnected.isProductionTarget,
        isTrue,
      );
    });

    test('state model covers required guarded states', () {
      const loading = NusukBridgeLoading<NusukPilgrimProfileDto>();
      const empty = NusukBridgeEmpty<NusukPilgrimProfileDto>(
        messageAr: 'لا توجد بيانات.',
      );
      const offline = NusukBridgeOffline<NusukPilgrimProfileDto>(
        messageAr: 'غير متصل.',
      );
      const needsLogin = NusukBridgeNeedsLogin<NusukPilgrimProfileDto>(
        messageAr: 'يلزم تسجيل الدخول عند التفعيل الرسمي.',
      );
      const needsConsent = NusukBridgeNeedsConsent<NusukPilgrimProfileDto>(
        messageAr: 'يلزم إذن صريح.',
        consentKey: 'profile_read',
      );
      const error = NusukBridgeError<NusukPilgrimProfileDto>(
        messageAr: 'تعذر تحميل البيانات.',
      );

      expect(loading, isA<NusukBridgeState<NusukPilgrimProfileDto>>());
      expect(empty.messageAr, isNotEmpty);
      expect(offline.messageAr, isNotEmpty);
      expect(needsLogin.messageAr, contains('تسجيل الدخول'));
      expect(needsConsent.consentKey, 'profile_read');
      expect(error.messageAr, isNotEmpty);
    });

    test('v292 endpoint paths remain stable under v294 contracts', () {
      final paths = NusukBridgePreviewRegistry.endpoints
          .map((endpoint) => endpoint.path)
          .toSet();

      expect(
        paths,
        containsAll(<String>{
          '/api/nusuk/me/profile',
          '/api/nusuk/me/journey-overview',
          '/api/nusuk/me/contacts',
          '/api/nusuk/me/feedback',
        }),
      );
    });

    test('local remote and repository interfaces are implementable', () async {
      final profile = NusukPilgrimProfileDto.fromJson(<String, dynamic>{
        'pilgrim_id': 'demo',
        'display_name_ar': 'مستخدم تجريبي',
        'national_id_masked': '******0000',
        'company_name_ar': 'حملة تجريبية',
        'group_name_ar': null,
      });

      final journey = NusukJourneyOverviewDto.fromJson(<String, dynamic>{
        'season_id': '1447H',
        'current_stage_id': 'documents_health',
        'readiness_score': 65,
        'next_action_ar': 'راجع الوثائق',
      });

      final contacts = NusukContactsDto.fromJson(<String, dynamic>{
        'supervisor_phone': '+000000000',
        'guide_phone': null,
        'emergency_channels': <String>['الطوارئ'],
        'assembly_points': <String>[],
      });

      const feedback = NusukFeedbackSubmissionDto(
        feedbackType: 'suggestion',
        stageId: 'documents_health',
        message: 'اقتراح تجريبي',
        auditContext: <String, dynamic>{
          'source': 'munasakna',
          'mode': 'preview',
        },
      );

      final local = _LocalDataSource(profile, journey, contacts);
      final remote = _RemoteDataSource(profile, journey, contacts);
      final repository = _Repository(profile, journey, contacts);

      expect((await local.getPilgrimProfile()).pilgrimId, 'demo');
      expect((await remote.getJourneyOverview()).readinessScore, 65);
      expect(repository.mode, NusukBridgeFeatureMode.guestDevelopment);

      await local.saveFeedbackDraft(feedback);
      await remote.submitFeedback(feedback);
      await repository.saveFeedbackDraft(feedback);
      await repository.submitFeedback(feedback);

      expect(local.savedDrafts, 1);
      expect(remote.submissions, 1);
      expect(repository.savedDrafts, 1);
      expect(repository.submissions, 1);
    });
  });
}

final class _LocalDataSource implements NusukLocalPreviewDataSource {
  _LocalDataSource(this.profile, this.journey, this.contacts);

  final NusukPilgrimProfileDto profile;
  final NusukJourneyOverviewDto journey;
  final NusukContactsDto contacts;
  int savedDrafts = 0;

  @override
  Future<NusukContactsDto> getContacts() async => contacts;

  @override
  Future<NusukJourneyOverviewDto> getJourneyOverview() async => journey;

  @override
  Future<NusukPilgrimProfileDto> getPilgrimProfile() async => profile;

  @override
  Future<void> saveFeedbackDraft(NusukFeedbackSubmissionDto submission) async {
    savedDrafts += 1;
  }
}

final class _RemoteDataSource implements NusukRemoteDataSource {
  _RemoteDataSource(this.profile, this.journey, this.contacts);

  final NusukPilgrimProfileDto profile;
  final NusukJourneyOverviewDto journey;
  final NusukContactsDto contacts;
  int submissions = 0;

  @override
  Future<NusukContactsDto> getContacts() async => contacts;

  @override
  Future<NusukJourneyOverviewDto> getJourneyOverview() async => journey;

  @override
  Future<NusukPilgrimProfileDto> getPilgrimProfile() async => profile;

  @override
  Future<void> submitFeedback(NusukFeedbackSubmissionDto submission) async {
    submissions += 1;
  }
}

final class _Repository implements NusukBridgeRepository {
  _Repository(this.profile, this.journey, this.contacts);

  final NusukPilgrimProfileDto profile;
  final NusukJourneyOverviewDto journey;
  final NusukContactsDto contacts;
  int savedDrafts = 0;
  int submissions = 0;

  @override
  NusukBridgeFeatureMode get mode => NusukBridgeFeatureMode.guestDevelopment;

  @override
  Future<NusukContactsDto> getContacts() async => contacts;

  @override
  Future<NusukJourneyOverviewDto> getJourneyOverview() async => journey;

  @override
  Future<NusukPilgrimProfileDto> getPilgrimProfile() async => profile;

  @override
  Future<void> saveFeedbackDraft(NusukFeedbackSubmissionDto submission) async {
    savedDrafts += 1;
  }

  @override
  Future<void> submitFeedback(NusukFeedbackSubmissionDto submission) async {
    submissions += 1;
  }
}
