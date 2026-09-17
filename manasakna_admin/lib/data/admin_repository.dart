import 'package:supabase_flutter/supabase_flutter.dart';

typedef AdminRpcInvoker =
    Future<dynamic> Function(
      String functionName, {
      Map<String, dynamic>? params,
    });

class AdminRepository {
  AdminRepository(
    SupabaseClient client, {
    this.syntheticToolsEnabled = false,
    DateTime Function()? now,
  }) : _rpc = ((functionName, {params}) =>
           client.rpc(functionName, params: params)),
       _now = now ?? DateTime.now;

  AdminRepository.withRpcInvoker(
    this._rpc, {
    this.syntheticToolsEnabled = false,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final AdminRpcInvoker _rpc;
  final DateTime Function() _now;
  final bool syntheticToolsEnabled;

  void _requireSyntheticTools() {
    if (!syntheticToolsEnabled) {
      throw StateError('MANASAKNA_SYNTHETIC_TOOLS_DISABLED');
    }
  }

  Future<Map<String, dynamic>> adminContext() async {
    final data = await _rpc('rpc_manasakna_admin_context_v1');
    return _map(data);
  }

  Future<Map<String, dynamic>> dashboard() async {
    final data = await _rpc('rpc_manasakna_dashboard_v1');
    return _map(data);
  }

  Future<List<Map<String, dynamic>>> seasons() async {
    final data = await _rpc('rpc_manasakna_seasons_v1');
    return _rows(data);
  }

  Future<Map<String, dynamic>> upsertSeason(
    Map<String, dynamic> payload,
  ) async {
    final data = await _rpc(
      'rpc_manasakna_season_upsert_v1',
      params: {'p_payload': payload},
    );
    return _singleRow(data);
  }

  Future<List<Map<String, dynamic>>> lotteryRounds({String? seasonId}) async {
    final data = await _rpc(
      'rpc_manasakna_lottery_rounds_v1',
      params: {'p_season_id': seasonId},
    );
    return _rows(data);
  }

  Future<List<Map<String, dynamic>>> lotteryResults(String roundId) async {
    final data = await _rpc(
      'rpc_manasakna_lottery_results_v1',
      params: {'p_round_id': roundId},
    );
    return _rows(data);
  }

  Future<Map<String, dynamic>> seedSyntheticFixture() async {
    _requireSyntheticTools();
    final data = await _rpc('rpc_manasakna_seed_synthetic_lottery_fixture_v1');
    return _map(data);
  }

  Future<Map<String, dynamic>> runSyntheticE2E() async {
    _requireSyntheticTools();
    final data = await _rpc('rpc_manasakna_synthetic_e2e_v1');
    return _map(data);
  }

  Future<List<Map<String, dynamic>>> campaigns({String? seasonId}) async {
    final data = await _rpc(
      'rpc_manasakna_campaigns_v1',
      params: {'p_season_id': seasonId},
    );
    return _rows(data);
  }

  Future<Map<String, dynamic>> upsertCampaign(
    Map<String, dynamic> payload,
  ) async {
    final data = await _rpc(
      'rpc_manasakna_campaign_upsert_v1',
      params: {'p_payload': payload},
    );
    return _singleRow(data);
  }

  Future<Map<String, dynamic>> upsertGroup(Map<String, dynamic> payload) async {
    final data = await _rpc(
      'rpc_manasakna_group_upsert_v1',
      params: {'p_payload': payload},
    );
    return _singleRow(data);
  }

  Future<List<Map<String, dynamic>>> campaignGroups(String campaignId) async {
    final data = await _rpc(
      'rpc_manasakna_campaign_groups_v1',
      params: {'p_campaign_id': campaignId},
    );
    return _rows(data);
  }

  Future<List<Map<String, dynamic>>> groupMembers(String groupId) async {
    final data = await _rpc(
      'rpc_manasakna_group_members_v1',
      params: {'p_group_id': groupId},
    );
    return _rows(data);
  }

  Future<Map<String, dynamic>> assignSelectedPilgrim({
    required String groupId,
    required String lotteryEntryId,
  }) async {
    final data = await _rpc(
      'rpc_manasakna_group_member_assign_v1',
      params: {'p_group_id': groupId, 'p_lottery_entry_id': lotteryEntryId},
    );
    return _singleRow(data);
  }

  Future<Map<String, dynamic>> issueActivation({
    required String campaignId,
    required String applicantRef,
    required DateTime expiresAt,
  }) async {
    final expiryUtc = expiresAt.toUtc();
    if (!expiryUtc.isAfter(_now().toUtc())) {
      throw ArgumentError.value(
        expiresAt,
        'expiresAt',
        'Activation expiry must be in the future.',
      );
    }
    final data = await _rpc(
      'rpc_manasakna_issue_activation_v1',
      params: {
        'p_campaign_id': campaignId,
        'p_applicant_ref': applicantRef,
        'p_expires_at': expiryUtc.toIso8601String(),
      },
    );
    return _map(data);
  }

  Future<List<Map<String, dynamic>>> content({String? type}) async {
    final data = await _rpc(
      'rpc_manasakna_content_v1',
      params: {'p_content_type': type},
    );
    return _rows(data);
  }

  Future<Map<String, dynamic>> upsertContent(
    Map<String, dynamic> payload,
  ) async {
    final data = await _rpc(
      'rpc_manasakna_content_upsert_v1',
      params: {'p_payload': payload},
    );
    return _singleRow(data);
  }

  Future<List<Map<String, dynamic>>> notifications() async {
    final data = await _rpc('rpc_manasakna_notifications_v1');
    return _rows(data);
  }

  Future<Map<String, dynamic>> upsertNotification(
    Map<String, dynamic> payload,
  ) async {
    final data = await _rpc(
      'rpc_manasakna_notification_upsert_v1',
      params: {'p_payload': payload},
    );
    return _singleRow(data);
  }

  Future<List<Map<String, dynamic>>> audit({int limit = 100}) async {
    final data = await _rpc(
      'rpc_manasakna_audit_v1',
      params: {'p_limit': limit},
    );
    return _rows(data);
  }

  Map<String, dynamic> _map(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw StateError('Expected JSON object, got ${data.runtimeType}.');
  }

  List<Map<String, dynamic>> _rows(dynamic data) {
    if (data is! List) {
      throw StateError('Expected JSON list, got ${data.runtimeType}.');
    }
    return data
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList(growable: false);
  }

  Map<String, dynamic> _singleRow(dynamic data) {
    if (data is List && data.isNotEmpty) {
      return Map<String, dynamic>.from(data.first as Map);
    }
    return _map(data);
  }
}
