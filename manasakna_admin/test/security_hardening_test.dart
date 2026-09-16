import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manasakna_admin/config/admin_environment.dart';
import 'package:manasakna_admin/data/admin_repository.dart';
import 'package:manasakna_admin/presentation/dashboard_page.dart';

void main() {
  const legacyServiceRoleJwt =
      'eyJhbGciOiJub25lIn0.eyJyb2xlIjoic2VydmljZV9yb2xlIn0.signature';

  test('client key policy rejects privileged keys', () {
    expect(AdminEnvironment.isSafeClientKey('sb_publishable_test'), isTrue);
    expect(AdminEnvironment.isSafeClientKey('legacy-anon-key'), isTrue);
    expect(AdminEnvironment.isSafeClientKey('sb_secret_test'), isFalse);
    expect(AdminEnvironment.isSafeClientKey(legacyServiceRoleJwt), isFalse);
  });

  test('synthetic tools remain opt-in and hard safety flags stay off', () {
    expect(AdminEnvironment.syntheticToolsEnabled, isFalse);
    expect(AdminEnvironment.realPilgrimDataEnabled, isFalse);
    expect(AdminEnvironment.productionEnabled, isFalse);
    expect(AdminEnvironment.nusukIntegrationEnabled, isFalse);
  });
  test('activation issuance requires and forwards future expiry', () async {
    final fixedNow = DateTime.utc(2026, 9, 16, 10);
    final expiry = DateTime.utc(2026, 9, 17, 10);
    String? calledFunction;
    Map<String, dynamic>? calledParams;
    final repository = AdminRepository.withRpcInvoker((
      functionName, {
      params,
    }) async {
      calledFunction = functionName;
      calledParams = params;
      return <String, dynamic>{'activation_id': 'a1'};
    }, now: () => fixedNow);

    await repository.issueActivation(
      campaignId: 'campaign-1',
      applicantRef: 'SYNTH-01',
      expiresAt: expiry,
    );

    expect(calledFunction, 'rpc_manasakna_issue_activation_v1');
    expect(calledParams?['p_campaign_id'], 'campaign-1');
    expect(calledParams?['p_applicant_ref'], 'SYNTH-01');
    expect(calledParams?['p_expires_at'], expiry.toIso8601String());
  });
  test('activation issuance rejects non-future expiry before RPC', () async {
    final fixedNow = DateTime.utc(2026, 9, 16, 10);
    var rpcCalled = false;
    final repository = AdminRepository.withRpcInvoker((
      functionName, {
      params,
    }) async {
      rpcCalled = true;
      return <String, dynamic>{};
    }, now: () => fixedNow);

    await expectLater(
      repository.issueActivation(
        campaignId: 'campaign-1',
        applicantRef: 'SYNTH-01',
        expiresAt: fixedNow,
      ),
      throwsArgumentError,
    );
    expect(rpcCalled, isFalse);
  });

  test('synthetic fixture RPCs fail closed when tooling is disabled', () async {
    var rpcCalled = false;
    final repository = AdminRepository.withRpcInvoker((
      functionName, {
      params,
    }) async {
      rpcCalled = true;
      return <String, dynamic>{};
    });
    await expectLater(
      repository.seedSyntheticFixture(),
      throwsA(isA<StateError>()),
    );
    await expectLater(repository.runSyntheticE2E(), throwsA(isA<StateError>()));
    expect(rpcCalled, isFalse);
  });

  testWidgets('dashboard hides synthetic mutation controls by default', (
    tester,
  ) async {
    final repository = AdminRepository.withRpcInvoker((
      functionName, {
      params,
    }) async {
      if (functionName == 'rpc_manasakna_lottery_rounds_v1') {
        return <Map<String, dynamic>>[];
      }
      return <String, dynamic>{};
    });

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(1200, 800)),
          child: DashboardPage(repository: repository, adminContext: const {}),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('admin-nav-2')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('synthetic-tools-disabled')),
      findsOneWidget,
    );
    expect(find.text('إنشاء وتشغيل عينة 12 حالة'), findsNothing);
    expect(find.text('E2E: القرعة ← المجموعة ← التفعيل'), findsNothing);
  });
}
