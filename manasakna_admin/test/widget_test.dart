import 'package:flutter_test/flutter_test.dart';
import 'package:manasakna_admin/config/admin_environment.dart';
import 'package:manasakna_admin/main.dart';

void main() {
  test('V1 hard safety flags remain disabled', () {
    expect(AdminEnvironment.realPilgrimDataEnabled, isFalse);
    expect(AdminEnvironment.productionEnabled, isFalse);
    expect(AdminEnvironment.nusukIntegrationEnabled, isFalse);
  });

  testWidgets('fails closed when Supabase configuration is absent', (
    tester,
  ) async {
    expect(AdminEnvironment.isConfigured, isFalse);
    await tester.pumpWidget(const ManasaknaAdminApp());
    expect(find.textContaining('Fail-Closed'), findsOneWidget);
    expect(find.textContaining('لا توجد بيانات حقيقية'), findsOneWidget);
  });
}
