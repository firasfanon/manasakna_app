import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manasakna_admin/data/admin_repository.dart';
import 'package:manasakna_admin/presentation/admin_presenters.dart';
import 'package:manasakna_admin/presentation/dashboard_page.dart';

void main() {
  test('presentation localizes operational status and content types', () {
    expect(AdminPresentation.statusAr('published'), 'منشور');
    expect(AdminPresentation.statusAr('executed'), 'نُفذت');
    expect(AdminPresentation.statusAr('waitlisted'), 'قائمة انتظار');
    expect(AdminPresentation.contentTypeAr('fatwa'), 'فتوى');
    expect(AdminPresentation.roleAr('operations_admin'), 'مدير العمليات');
    expect(
      AdminPresentation.audienceAr(<String, dynamic>{'kind': 'all'}),
      'جميع الحجاج',
    );
  });

  testWidgets('dashboard productizes metrics and hides raw admin context', (
    tester,
  ) async {
    final repository = _repository();

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(1280, 900)),
          child: DashboardPage(
            repository: repository,
            adminContext: const <String, dynamic>{
              'name': 'مدير الاختبار',
              'email': 'internal@example.com',
              'is_superuser': true,
              'roles': <String>['operations_admin'],
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('المحتوى المنشور'), findsOneWidget);
    expect(find.text('إشعارات قيد الإجراء'), findsOneWidget);
    expect(find.textContaining('مرحبًا، مدير الاختبار'), findsOneWidget);
    expect(find.textContaining('admin_context'), findsNothing);
    expect(find.textContaining('internal@example.com'), findsNothing);
  });

  testWidgets('content and audit use human-readable Arabic presentation', (
    tester,
  ) async {
    final repository = _repository();

    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(1280, 900)),
          child: DashboardPage(
            repository: repository,
            adminContext: const <String, dynamic>{},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('admin-nav-4')));
    await tester.pumpAndSettle();
    expect(find.text('فتوى تجريبية'), findsOneWidget);
    expect(find.text('منشور'), findsWidgets);
    expect(find.text('published'), findsNothing);
    expect(find.text('بحث'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('admin-nav-6')));
    await tester.pumpAndSettle();
    expect(find.text('إصدار رمز تفعيل'), findsOneWidget);
    expect(find.textContaining('activation_issue'), findsNothing);
  });
}

AdminRepository _repository() {
  return AdminRepository.withRpcInvoker((functionName, {params}) async {
    switch (functionName) {
      case 'rpc_manasakna_dashboard_v1':
        return <String, dynamic>{
          'seasons': 4,
          'lottery_rounds': 4,
          'campaigns': 4,
          'published_content': 10,
          'pending_notifications': 0,
          'audit_events': 36,
        };
      case 'rpc_manasakna_content_v1':
        return <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 'content-1',
            'content_type': 'fatwa',
            'slug': 'fatwa-test',
            'title_ar': 'فتوى تجريبية',
            'body_ar': 'نص تجريبي',
            'status': 'published',
            'published_at': '2026-09-17T10:00:00Z',
            'metadata': <String, dynamic>{'authority_label': 'اللجنة الشرعية'},
          },
        ];
      case 'rpc_manasakna_audit_v1':
        return <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 36,
            'actor_user_id': '11111111-2222-3333-4444-555555555555',
            'action_key': 'activation_issue',
            'entity_type': 'activation_token',
            'entity_id': 'activation-1',
            'created_at': '2026-09-17T10:00:00Z',
          },
        ];
      case 'rpc_manasakna_seasons_v1':
      case 'rpc_manasakna_lottery_rounds_v1':
      case 'rpc_manasakna_campaigns_v1':
      case 'rpc_manasakna_notifications_v1':
        return <Map<String, dynamic>>[];
      default:
        return <String, dynamic>{};
    }
  });
}
