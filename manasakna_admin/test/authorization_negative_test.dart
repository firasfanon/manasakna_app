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
}
