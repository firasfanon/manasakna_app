import '../domain/manasikuna_1448_contract_policy.dart';
import '../domain/manasikuna_1448_models.dart';
import '../domain/manasikuna_1448_provider_contracts.dart';

class Manasikuna1448SyntheticActivationBundle {
  const Manasikuna1448SyntheticActivationBundle({
    required this.credential,
    required this.profileProvider,
    required this.operationalProvider,
  });

  final ActivationCredential credential;
  final PilgrimProfileProvider profileProvider;
  final CampaignOperationalProvider operationalProvider;
}

class Manasikuna1448SyntheticSource {
  const Manasikuna1448SyntheticSource();

  static const String demoToken = 'M1448-X7K2-9Q4P-2L8N';
  static const String syntheticPackId = 'pack-synthetic-1448-001';
  static const String syntheticCampaignReference = 'campaign-synthetic-1448-01';
  static const String syntheticGroupReference = 'group-synthetic-1448-a';
  static const String syntheticAuthority =
      'official-hajj-system.synthetic-fixture';

  Manasikuna1448SyntheticActivationBundle? bundleForToken(
    String rawToken, {
    DateTime? now,
  }) {
    final token = rawToken.trim();
    if (token.isEmpty || token != demoToken) {
      return null;
    }

    final clock = (now ?? DateTime.now()).toUtc();
    final credential = ActivationCredential(
      opaqueToken: token,
      issuedAt: clock.subtract(const Duration(minutes: 5)),
      expiresAt: clock.add(const Duration(days: 90)),
      packId: syntheticPackId,
    );

    return Manasikuna1448SyntheticActivationBundle(
      credential: credential,
      profileProvider: _SyntheticPilgrimProfileProvider(clock: clock),
      operationalProvider: _SyntheticCampaignOperationalProvider(clock: clock),
    );
  }
}

class Manasikuna1448NullStandaloneProfileProvider
    implements PilgrimProfileProvider {
  const Manasikuna1448NullStandaloneProfileProvider();

  @override
  String get providerId => 'standalone.local.no-profile';

  @override
  Future<OfficialPilgrimSeed?> loadProfile({
    ActivationCredential? activation,
  }) async {
    return null;
  }
}

class _SyntheticPilgrimProfileProvider implements PilgrimProfileProvider {
  const _SyntheticPilgrimProfileProvider({required this.clock});

  final DateTime clock;

  @override
  String get providerId => 'official-seed.synthetic.1448';

  @override
  Future<OfficialPilgrimSeed?> loadProfile({
    ActivationCredential? activation,
  }) async {
    const sourceRevision = 'synthetic-1448-seed-r1';

    return OfficialPilgrimSeed(
      officialReference: 'APPROVED-SYNTH-1448-001',
      fullNameAr: 'حاج تجريبي 1448',
      acceptanceStatus: OfficialPilgrimAcceptanceStatus.approved,
      sourceAuthority: Manasikuna1448SyntheticSource.syntheticAuthority,
      sourceRevision: sourceRevision,
      effectiveAt: clock,
      campaignReference:
          Manasikuna1448SyntheticSource.syntheticCampaignReference,
      groupReference: Manasikuna1448SyntheticSource.syntheticGroupReference,
      contractMetadata: Manasikuna1448ContractMetadata(
        contractVersion:
            Manasikuna1448WaveCContractPolicy.pilgrimSeedContractVersion,
        authorityModel: Manasikuna1448WaveCContractPolicy.authorityModel,
        sourceAuthority: Manasikuna1448SyntheticSource.syntheticAuthority,
        sourceRevision: sourceRevision,
        provenanceReference:
            'synthetic://manasakna/1448/official-pilgrim-seed/001',
        dataClass: Manasikuna1448ContractDataClass.syntheticFixture,
        approvalState:
            Manasikuna1448ContractApprovalState.approvedForFixtureUse,
        issuedAt: clock.subtract(const Duration(minutes: 5)),
        expiresAt: clock.add(const Duration(days: 90)),
        updateSequence: 1,
      ),
    );
  }
}

class _SyntheticCampaignOperationalProvider
    implements CampaignOperationalProvider {
  const _SyntheticCampaignOperationalProvider({required this.clock});

  final DateTime clock;

  @override
  String get providerId => 'campaign-pack.synthetic.1448';

  @override
  Future<CampaignOperationalPack?> loadCampaignPack({
    required OfficialPilgrimSeed pilgrim,
    ActivationCredential? activation,
  }) async {
    return CampaignOperationalPack(
      packId: Manasikuna1448SyntheticSource.syntheticPackId,
      schemaVersion: 1,
      campaignReference:
          Manasikuna1448SyntheticSource.syntheticCampaignReference,
      campaignNameAr: 'حملة الرفيق 1448 التجريبية',
      updatedAt: clock,
      groupReference: Manasikuna1448SyntheticSource.syntheticGroupReference,
      supervisor: const OperationalContact(
        roleAr: 'مشرف المجموعة',
        nameAr: 'مشرف تجريبي',
        phone: '+0000000000',
      ),
      hotelNameAr: 'سكن تجريبي — مكة',
      hotelAddressAr: 'عنوان تجريبي محفوظ محليًا',
      transportLabelAr: 'حافلة المجموعة A — تجريبية',
      minaCampAr: 'مخيم منى التجريبي A',
      arafatCampAr: 'مخيم عرفات التجريبي A',
      meetingPoints: const <CampaignMeetingPoint>[
        CampaignMeetingPoint(
          id: 'meeting-hotel-lobby',
          labelAr: 'ردهة السكن',
          descriptionAr: 'نقطة تجمع تجريبية قبل التحرك.',
          latitude: 21.4225,
          longitude: 39.8262,
        ),
        CampaignMeetingPoint(
          id: 'meeting-bus-zone',
          labelAr: 'منطقة الحافلة',
          descriptionAr: 'نقطة تجريبية للالتقاء بالمجموعة.',
          latitude: 21.4187,
          longitude: 39.8253,
        ),
      ],
      schedule: <CampaignScheduleItem>[
        CampaignScheduleItem(
          id: 'schedule-orientation',
          titleAr: 'لقاء المجموعة التعريفي — تجريبي',
          startsAt: clock.add(const Duration(hours: 2)),
          endsAt: clock.add(const Duration(hours: 3)),
          meetingPointId: 'meeting-hotel-lobby',
          notesAr: 'موعد تجريبي لا يمثل جدولًا رسميًا.',
        ),
        CampaignScheduleItem(
          id: 'schedule-movement',
          titleAr: 'استعداد للتحرك — تجريبي',
          startsAt: clock.add(const Duration(days: 1, hours: 1)),
          meetingPointId: 'meeting-bus-zone',
          notesAr: 'تحقق من تحديث الحملة قبل الحركة.',
        ),
        CampaignScheduleItem(
          id: 'schedule-camp',
          titleAr: 'الوصول إلى المخيم — تجريبي',
          startsAt: clock.add(const Duration(days: 2)),
          notesAr: 'البيانات في هذه الدفعة Synthetic فقط.',
        ),
      ],
      emergencyContacts: const <OperationalContact>[
        OperationalContact(
          roleAr: 'طوارئ الحملة',
          nameAr: 'نقطة اتصال تجريبية',
          phone: '+0000000001',
        ),
        OperationalContact(
          roleAr: 'دعم المجموعة',
          nameAr: 'مساندة تجريبية',
          phone: '+0000000002',
        ),
      ],
      contractMetadata: Manasikuna1448ContractMetadata(
        contractVersion:
            Manasikuna1448WaveCContractPolicy.campaignPackContractVersion,
        authorityModel: Manasikuna1448WaveCContractPolicy.authorityModel,
        sourceAuthority: Manasikuna1448SyntheticSource.syntheticAuthority,
        sourceRevision: 'synthetic-1448-campaign-pack-r1',
        provenanceReference:
            'synthetic://manasakna/1448/campaign-operational-pack/001',
        dataClass: Manasikuna1448ContractDataClass.syntheticFixture,
        approvalState:
            Manasikuna1448ContractApprovalState.approvedForFixtureUse,
        issuedAt: clock.subtract(const Duration(minutes: 5)),
        expiresAt: clock.add(const Duration(days: 90)),
        updateSequence: 1,
        integrityAlgorithm: 'SHA-256',
        integrityDigest:
            '6f28db4c35105b2d57679e3ce0545526247dc52836da47fda795466484616164',
        signatureReference:
            'synthetic://manasakna/1448/signature/campaign-pack-001',
      ),
    );
  }
}
