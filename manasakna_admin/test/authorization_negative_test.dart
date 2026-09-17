import 'package:flutter_test/flutter_test.dart';
import 'package:manasakna_admin/data/admin_repository.dart';

void main() {
  test('backend authorization denial is surfaced fail-closed', () async {
    var rpcCalls = 0;
    final repository = AdminRepository.withRpcInvoker((
      functionName, {
      params,
    }) async {
      rpcCalls++;
      throw StateError('MANASAKNA_FORBIDDEN');
    });

    await expectLater(
      repository.upsertContent(<String, dynamic>{
        'content_type': 'guidance',
        'slug': 'denied-write',
      }),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          'MANASAKNA_FORBIDDEN',
        ),
      ),
    );
    expect(rpcCalls, 1);
  });

  test('server expiry bound denial is surfaced fail-closed', () async {
    final fixedNow = DateTime.utc(2026, 9, 16, 10);
    var rpcCalls = 0;
    final repository = AdminRepository.withRpcInvoker((
      functionName, {
      params,
    }) async {
      rpcCalls++;
      throw StateError('MANASAKNA_ACTIVATION_EXPIRY_TOO_FAR');
    }, now: () => fixedNow);

    await expectLater(
      repository.issueActivation(
        campaignId: 'campaign-1',
        applicantRef: 'SYNTH-01',
        expiresAt: fixedNow.add(const Duration(days: 8)),
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          'MANASAKNA_ACTIVATION_EXPIRY_TOO_FAR',
        ),
      ),
    );
    expect(rpcCalls, 1);
  });
}
