import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/admin_environment.dart';
import '../data/admin_repository.dart';
import 'admin_presenters.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    super.key,
    required this.repository,
    required this.adminContext,
  });

  final AdminRepository repository;
  final Map<String, dynamic> adminContext;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selected = 0;
  int _refreshEpoch = 0;

  static const _items = <_AdminNavItem>[
    _AdminNavItem('لوحة المتابعة', Icons.dashboard_outlined),
    _AdminNavItem('المواسم', Icons.calendar_month_outlined),
    _AdminNavItem('القرعة والأهلية', Icons.how_to_reg_outlined),
    _AdminNavItem('الحملات والمجموعات', Icons.groups_outlined),
    _AdminNavItem('المحتوى والفتاوى', Icons.menu_book_outlined),
    _AdminNavItem('الإشعارات', Icons.notifications_outlined),
    _AdminNavItem('سجل التدقيق', Icons.fact_check_outlined),
  ];

  void _refresh() => setState(() => _refreshEpoch++);

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 960;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AdminEnvironment.productNameAr),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Chip(
                key: const ValueKey('environment-status-chip'),
                avatar: const Icon(Icons.shield_outlined, size: 18),
                label: const Text(AdminEnvironment.environmentLabel),
              ),
            ),
          ),
          IconButton(
            tooltip: 'تحديث البيانات',
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'تسجيل الخروج',
            onPressed: () => Supabase.instance.client.auth.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: wide ? null : Drawer(child: _navigation(closeOnTap: true)),
      body: Row(
        children: [
          if (wide)
            SizedBox(
              width: 272,
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: _navigation(closeOnTap: false),
              ),
            ),
          Expanded(child: _buildSection()),
        ],
      ),
    );
  }

  Widget _navigation({required bool closeOnTap}) {
    final roles = _adminRoleLabels(widget.adminContext);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          ListTile(
            leading: const Icon(Icons.mosque_outlined),
            title: const Text('مناسكنا 1448'),
            subtitle: Text(
              roles.isEmpty
                  ? 'لوحة الإدارة والتشغيل'
                  : 'لوحة الإدارة والتشغيل • ${roles.first}',
            ),
          ),
          const Divider(),
          for (var i = 0; i < _items.length; i++)
            ListTile(
              key: ValueKey('admin-nav-$i'),
              selected: i == _selected,
              leading: Icon(_items[i].icon),
              title: Text(_items[i].label),
              onTap: () {
                setState(() => _selected = i);
                if (closeOnTap) Navigator.of(context).pop();
              },
            ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: _EnvironmentNotice(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection() {
    return switch (_selected) {
      0 => _DashboardOverview(
        key: ValueKey('dashboard-$_refreshEpoch'),
        repository: widget.repository,
        adminContext: widget.adminContext,
      ),
      1 => _SeasonsSection(
        key: ValueKey('seasons-$_refreshEpoch'),
        repository: widget.repository,
        onSeedSeason: widget.repository.syntheticToolsEnabled
            ? _seedSeason1448
            : null,
      ),
      2 => _LotterySection(
        key: ValueKey('lottery-$_refreshEpoch'),
        repository: widget.repository,
        onChanged: _refresh,
      ),
      3 => _CampaignsSection(
        key: ValueKey('campaigns-$_refreshEpoch'),
        repository: widget.repository,
      ),
      4 => _ContentSection(
        key: ValueKey('content-$_refreshEpoch'),
        repository: widget.repository,
        onSeed: widget.repository.syntheticToolsEnabled ? _seedContent : null,
      ),
      5 => _NotificationsSection(
        key: ValueKey('notifications-$_refreshEpoch'),
        repository: widget.repository,
        onSeed: widget.repository.syntheticToolsEnabled
            ? _seedNotification
            : null,
      ),
      _ => _AuditSection(
        key: ValueKey('audit-$_refreshEpoch'),
        repository: widget.repository,
      ),
    };
  }

  Future<void> _seedSeason1448() async {
    await _runAction(() async {
      await widget.repository.upsertSeason({
        'season_code': 'H1448',
        'title_ar': 'موسم حج 1448',
        'hijri_year': 1448,
        'status': 'draft',
        'settings': {'synthetic_only': true},
      });
    }, 'تم إنشاء/تحديث موسم 1448 التجريبي.');
  }

  Future<void> _seedContent() async {
    await _runAction(() async {
      await widget.repository.upsertContent({
        'content_type': 'guidance',
        'slug': 'guidance-synthetic-h1448',
        'title_ar': 'تعليمات تجريبية لموسم 1448',
        'body_ar': 'محتوى اصطناعي لاستخدام بيئة الاختبار فقط.',
        'status': 'draft',
        'season_code': 'H1448',
      });
    }, 'تم إنشاء مسودة محتوى تجريبية.');
  }

  Future<void> _seedNotification() async {
    await _runAction(() async {
      await widget.repository.upsertNotification({
        'season_code': 'H1448',
        'title_ar': 'تنبيه تجريبي 1448',
        'body_ar': 'هذا إشعار اصطناعي لاختبار لوحة مناسكنا.',
        'audience': {'kind': 'all'},
        'status': 'draft',
      });
    }, 'تم إنشاء إشعار تجريبي.');
  }

  Future<void> _runAction(
    Future<void> Function() action,
    String successMessage,
  ) async {
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMessage)));
      _refresh();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشلت العملية: $error')));
    }
  }
}

class _EnvironmentNotice extends StatelessWidget {
  const _EnvironmentNotice();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.secondaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.science_outlined, size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'بيئة تشغيل محمية ببيانات تجريبية فقط. '
                'البيانات الحقيقية وتكامل نسك والإنتاج غير مفعّلة.',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardOverview extends StatelessWidget {
  const _DashboardOverview({
    super.key,
    required this.repository,
    required this.adminContext,
  });

  final AdminRepository repository;
  final Map<String, dynamic> adminContext;

  @override
  Widget build(BuildContext context) {
    final name = '${adminContext['name'] ?? ''}'.trim();
    final roles = _adminRoleLabels(adminContext);
    return FutureBuilder<Map<String, dynamic>>(
      future: repository.dashboard(),
      builder: (context, snapshot) {
        return _SectionFrame(
          title: 'لوحة المتابعة',
          subtitle: 'مؤشرات تشغيلية لحالة مناسكنا في البيئة التجريبية المحمية',
          child: snapshot.connectionState != ConnectionState.done
              ? const _LoadingView()
              : snapshot.hasError
              ? _ErrorView(snapshot.error)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AdminIdentitySummary(
                      name: name,
                      roles: roles,
                      isSuperuser: adminContext['is_superuser'] == true,
                    ),
                    const SizedBox(height: 20),
                    _DashboardMetrics(data: snapshot.data ?? const {}),
                  ],
                ),
        );
      },
    );
  }
}

class _AdminIdentitySummary extends StatelessWidget {
  const _AdminIdentitySummary({
    required this.name,
    required this.roles,
    required this.isSuperuser,
  });

  final String name;
  final List<String> roles;
  final bool isSuperuser;

  @override
  Widget build(BuildContext context) {
    final labels = <String>[
      if (isSuperuser) 'مدير أعلى',
      ...roles.where((role) => role != 'مدير أعلى'),
    ];
    return Card(
      key: const ValueKey('admin-identity-summary'),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'جلسة إدارية موثقة' : 'مرحبًا، $name',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 6),
                const Text(
                  'تم التحقق من هوية المستخدم وسياق الصلاحيات عبر Supabase.',
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final label in labels) Chip(label: Text(label)),
                const Chip(
                  avatar: Icon(Icons.verified_user_outlined, size: 18),
                  label: Text('جلسة موثقة'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardMetrics extends StatelessWidget {
  const _DashboardMetrics({required this.data});

  final Map<String, dynamic> data;

  static const _metrics = <_MetricDefinition>[
    _MetricDefinition('seasons', 'المواسم', Icons.calendar_month_outlined),
    _MetricDefinition(
      'lottery_rounds',
      'جولات القرعة',
      Icons.how_to_reg_outlined,
    ),
    _MetricDefinition('campaigns', 'الحملات', Icons.campaign_outlined),
    _MetricDefinition(
      'published_content',
      'المحتوى المنشور',
      Icons.menu_book_outlined,
    ),
    _MetricDefinition(
      'pending_notifications',
      'إشعارات قيد الإجراء',
      Icons.notifications_active_outlined,
    ),
    _MetricDefinition(
      'audit_events',
      'أحداث التدقيق',
      Icons.fact_check_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth >= 900
            ? (constraints.maxWidth - 32) / 3
            : constraints.maxWidth >= 560
            ? (constraints.maxWidth - 16) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final metric in _metrics)
              SizedBox(
                width: cardWidth,
                child: _MetricCard(
                  key: ValueKey('dashboard-metric-${metric.key}'),
                  definition: metric,
                  value: data[metric.key] ?? 0,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({super.key, required this.definition, required this.value});

  final _MetricDefinition definition;
  final Object value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(radius: 24, child: Icon(definition.icon)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$value',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(definition.label),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeasonsSection extends StatelessWidget {
  const _SeasonsSection({
    super.key,
    required this.repository,
    required this.onSeedSeason,
  });

  final AdminRepository repository;
  final Future<void> Function()? onSeedSeason;

  @override
  Widget build(BuildContext context) {
    return _SectionFrame(
      title: 'المواسم',
      subtitle: 'إدارة دورة الموسم من التسجيل حتى الإغلاق والتشغيل الميداني',
      actions: [
        if (onSeedSeason != null)
          FilledButton.icon(
            onPressed: onSeedSeason,
            icon: const Icon(Icons.add),
            label: const Text('تهيئة موسم 1448 التجريبي'),
          ),
      ],
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.seasons(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const _LoadingView();
          }
          if (snapshot.hasError) return _ErrorView(snapshot.error);
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          return _RecordCollection(
            emptyLabel: 'لا توجد مواسم مسجلة.',
            rows: rows,
            modelBuilder: _seasonModel,
          );
        },
      ),
    );
  }
}

class _LotterySection extends StatefulWidget {
  const _LotterySection({
    super.key,
    required this.repository,
    required this.onChanged,
  });

  final AdminRepository repository;
  final VoidCallback onChanged;

  @override
  State<_LotterySection> createState() => _LotterySectionState();
}

class _LotterySectionState extends State<_LotterySection> {
  bool _busy = false;
  String? _message;

  Future<void> _seedFixture() async {
    await _runSynthetic(
      widget.repository.seedSyntheticFixture,
      successPrefix: 'تم إنشاء العينة التجريبية',
    );
  }

  Future<void> _runSyntheticE2E() async {
    await _runSynthetic(
      widget.repository.runSyntheticE2E,
      successPrefix: 'اكتمل اختبار المسار التجريبي',
    );
  }

  Future<void> _runSynthetic(
    Future<Map<String, dynamic>> Function() action, {
    required String successPrefix,
  }) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final result = await action();
      if (!mounted) return;
      setState(
        () => _message =
            '$successPrefix.\n${const JsonEncoder.withIndent('  ').convert(result)}',
      );
      widget.onChanged();
    } catch (error) {
      if (mounted) setState(() => _message = 'تعذر التنفيذ: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SectionFrame(
      title: 'القرعة والأهلية',
      subtitle: 'متابعة جولات القرعة ونتائجها ضمن حدود البيانات التجريبية',
      actions: widget.repository.syntheticToolsEnabled
          ? [
              FilledButton.icon(
                onPressed: _busy ? null : _seedFixture,
                icon: const Icon(Icons.science_outlined),
                label: Text(_busy ? 'جارٍ التنفيذ…' : 'إنشاء عينة 12 حالة'),
              ),
              OutlinedButton.icon(
                onPressed: _busy ? null : _runSyntheticE2E,
                icon: const Icon(Icons.verified_outlined),
                label: const Text('اختبار المسار الكامل'),
              ),
            ]
          : const [],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!widget.repository.syntheticToolsEnabled) ...[
            Card(
              key: const ValueKey('synthetic-tools-disabled'),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'أدوات الاختبار الاصطناعية متوقفة في هذه الجلسة. '
                        'لا يمكن إنشاء fixtures أو تشغيل E2E من الواجهة.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (_message != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(_message!),
              ),
            ),
            const SizedBox(height: 16),
          ],
          FutureBuilder<List<Map<String, dynamic>>>(
            future: widget.repository.lotteryRounds(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const _LoadingView();
              }
              if (snapshot.hasError) return _ErrorView(snapshot.error);
              final rounds = snapshot.data ?? const <Map<String, dynamic>>[];
              if (rounds.isEmpty) {
                return const _EmptyView('لا توجد جولات قرعة بعد.');
              }
              return Column(
                children: [
                  for (final round in rounds)
                    _LotteryRoundCard(
                      round: round,
                      repository: widget.repository,
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LotteryRoundCard extends StatelessWidget {
  const _LotteryRoundCard({required this.round, required this.repository});

  final Map<String, dynamic> round;
  final AdminRepository repository;

  @override
  Widget build(BuildContext context) {
    final roundId = '${round['id'] ?? ''}';
    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.how_to_reg_outlined),
        title: Text(
          '${round['title_ar'] ?? round['round_code'] ?? 'جولة قرعة'}',
        ),
        subtitle: Text(
          'السعة: ${round['capacity'] ?? '—'} • '
          '${AdminPresentation.statusAr(round['status'])}',
        ),
        trailing: _StatusChip(rawStatus: round['status']),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _InfoWrap(
                  items: [
                    _InfoItem('رمز الجولة', round['round_code']),
                    _InfoItem('نسخة الخوارزمية', round['algorithm_version']),
                    _InfoItem(
                      'وقت التنفيذ',
                      AdminPresentation.dateTimeAr(round['executed_at']),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (roundId.isNotEmpty)
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: repository.lotteryResults(roundId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const LinearProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Text('تعذر تحميل ملخص نتائج الجولة.');
                      }
                      final rows =
                          snapshot.data ?? const <Map<String, dynamic>>[];
                      int count(String outcome) =>
                          rows.where((row) => row['outcome'] == outcome).length;
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(label: Text('الإجمالي ${rows.length}')),
                          Chip(label: Text('مختار ${count('selected')}')),
                          Chip(label: Text('انتظار ${count('waitlisted')}')),
                          Chip(label: Text('غير مؤهل ${count('ineligible')}')),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CampaignsSection extends StatelessWidget {
  const _CampaignsSection({super.key, required this.repository});

  final AdminRepository repository;

  @override
  Widget build(BuildContext context) {
    return _SectionFrame(
      title: 'الحملات والمجموعات',
      subtitle:
          'الصورة التشغيلية للحملات والمجموعات والمشرفين والحجاج المخصصين',
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.campaigns(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const _LoadingView();
          }
          if (snapshot.hasError) return _ErrorView(snapshot.error);
          final rows = snapshot.data ?? const <Map<String, dynamic>>[];
          if (rows.isEmpty) {
            return const _EmptyView('لا توجد حملات مسجلة.');
          }
          return Column(
            children: [
              for (final campaign in rows)
                _CampaignCard(campaign: campaign, repository: repository),
            ],
          );
        },
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  const _CampaignCard({required this.campaign, required this.repository});

  final Map<String, dynamic> campaign;
  final AdminRepository repository;

  @override
  Widget build(BuildContext context) {
    final campaignId = '${campaign['id'] ?? ''}';
    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.campaign_outlined),
        title: Text(
          '${campaign['title_ar'] ?? campaign['campaign_code'] ?? 'حملة'}',
        ),
        subtitle: Text(
          '${campaign['campaign_code'] ?? '—'} • '
          '${AdminPresentation.statusAr(campaign['status'])}',
        ),
        trailing: _StatusChip(rawStatus: campaign['status']),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _InfoWrap(
                  items: [
                    _InfoItem(
                      'بداية الحملة',
                      AdminPresentation.dateTimeAr(campaign['starts_at']),
                    ),
                    _InfoItem(
                      'نهاية الحملة',
                      AdminPresentation.dateTimeAr(campaign['ends_at']),
                    ),
                    _InfoItem(
                      'الوصف',
                      '${campaign['description_ar'] ?? 'لا يوجد وصف'}',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (campaignId.isNotEmpty)
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: repository.campaignGroups(campaignId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const LinearProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return const Text('تعذر تحميل مجموعات الحملة.');
                      }
                      final groups =
                          snapshot.data ?? const <Map<String, dynamic>>[];
                      if (groups.isEmpty) {
                        return const Text('لا توجد مجموعات ضمن هذه الحملة.');
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'المجموعات (${groups.length})',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          for (final group in groups)
                            _GroupSummaryCard(
                              group: group,
                              repository: repository,
                            ),
                        ],
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupSummaryCard extends StatelessWidget {
  const _GroupSummaryCard({required this.group, required this.repository});

  final Map<String, dynamic> group;
  final AdminRepository repository;

  @override
  Widget build(BuildContext context) {
    final groupId = '${group['id'] ?? ''}';
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: ListTile(
        leading: const Icon(Icons.groups_2_outlined),
        title: Text('${group['title_ar'] ?? group['group_code'] ?? 'مجموعة'}'),
        subtitle: Text(
          'المشرف: ${group['supervisor_label'] ?? 'غير محدد'} • '
          'السعة: ${group['capacity'] ?? 'غير محددة'}',
        ),
        trailing: groupId.isEmpty
            ? _StatusChip(rawStatus: group['status'])
            : FutureBuilder<List<Map<String, dynamic>>>(
                future: repository.groupMembers(groupId),
                builder: (context, snapshot) {
                  final count = snapshot.hasData ? snapshot.data!.length : null;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _StatusChip(rawStatus: group['status']),
                      if (count != null)
                        Text(
                          '$count حاج',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({
    super.key,
    required this.repository,
    required this.onSeed,
  });

  final AdminRepository repository;
  final Future<void> Function()? onSeed;

  @override
  Widget build(BuildContext context) {
    return _SectionFrame(
      title: 'المحتوى والفتاوى',
      subtitle: 'المحتوى المنشور مع نوعه وحالة اعتماده ومصدره المسجل',
      actions: [
        if (onSeed != null)
          FilledButton.icon(
            onPressed: onSeed,
            icon: const Icon(Icons.add),
            label: const Text('إضافة محتوى تجريبي'),
          ),
      ],
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.content(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const _LoadingView();
          }
          if (snapshot.hasError) return _ErrorView(snapshot.error);
          return _RecordCollection(
            emptyLabel: 'لا يوجد محتوى بعد.',
            rows: snapshot.data ?? const <Map<String, dynamic>>[],
            modelBuilder: _contentModel,
          );
        },
      ),
    );
  }
}

class _NotificationsSection extends StatelessWidget {
  const _NotificationsSection({
    super.key,
    required this.repository,
    required this.onSeed,
  });

  final AdminRepository repository;
  final Future<void> Function()? onSeed;

  @override
  Widget build(BuildContext context) {
    return _SectionFrame(
      title: 'الإشعارات',
      subtitle: 'متابعة الجمهور المستهدف وجدولة الإرسال وحالة النشر',
      actions: [
        if (onSeed != null)
          FilledButton.icon(
            onPressed: onSeed,
            icon: const Icon(Icons.add_alert_outlined),
            label: const Text('إضافة إشعار تجريبي'),
          ),
      ],
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.notifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const _LoadingView();
          }
          if (snapshot.hasError) return _ErrorView(snapshot.error);
          return _RecordCollection(
            emptyLabel: 'لا توجد إشعارات بعد.',
            rows: snapshot.data ?? const <Map<String, dynamic>>[],
            modelBuilder: _notificationModel,
          );
        },
      ),
    );
  }
}

class _AuditSection extends StatelessWidget {
  const _AuditSection({super.key, required this.repository});

  final AdminRepository repository;

  @override
  Widget build(BuildContext context) {
    return _SectionFrame(
      title: 'سجل التدقيق',
      subtitle: 'تسلسل مفهوم للأفعال الإدارية والكيانات المتأثرة ووقت التنفيذ',
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: repository.audit(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const _LoadingView();
          }
          if (snapshot.hasError) return _ErrorView(snapshot.error);
          return _RecordCollection(
            emptyLabel: 'لا توجد أحداث تدقيق بعد.',
            rows: snapshot.data ?? const <Map<String, dynamic>>[],
            modelBuilder: _auditModel,
            showStatusFilter: false,
          );
        },
      ),
    );
  }
}

class _RecordCollection extends StatefulWidget {
  const _RecordCollection({
    required this.rows,
    required this.modelBuilder,
    required this.emptyLabel,
    this.showStatusFilter = true,
  });

  final List<Map<String, dynamic>> rows;
  final _RecordModel Function(Map<String, dynamic>) modelBuilder;
  final String emptyLabel;
  final bool showStatusFilter;

  @override
  State<_RecordCollection> createState() => _RecordCollectionState();
}

class _RecordCollectionState extends State<_RecordCollection> {
  String _query = '';
  String _status = 'all';

  @override
  Widget build(BuildContext context) {
    final models = widget.rows.map(widget.modelBuilder).toList(growable: false);
    final statuses =
        models
            .map((model) => model.rawStatus)
            .where((status) => status != null && status.isNotEmpty)
            .cast<String>()
            .toSet()
            .toList()
          ..sort();
    final visible = models
        .where((model) {
          final needle = _query.trim().toLowerCase();
          final matchesText =
              needle.isEmpty ||
              model.searchableText.toLowerCase().contains(needle);
          final matchesStatus = _status == 'all' || model.rawStatus == _status;
          return matchesText && matchesStatus;
        })
        .toList(growable: false);

    if (models.isEmpty) return _EmptyView(widget.emptyLabel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _RecordFilterBar(
          showStatusFilter: widget.showStatusFilter && statuses.length > 1,
          statuses: statuses,
          selectedStatus: _status,
          onStatusChanged: (value) => setState(() => _status = value),
          onQueryChanged: (value) => setState(() => _query = value),
        ),
        const SizedBox(height: 12),
        if (visible.isEmpty)
          const _EmptyView('لا توجد نتائج مطابقة للبحث أو الفلتر.')
        else
          for (final model in visible) _RecordCard(model: model),
      ],
    );
  }
}

class _RecordFilterBar extends StatelessWidget {
  const _RecordFilterBar({
    required this.showStatusFilter,
    required this.statuses,
    required this.selectedStatus,
    required this.onStatusChanged,
    required this.onQueryChanged,
  });

  final bool showStatusFilter;
  final List<String> statuses;
  final String selectedStatus;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onQueryChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 320,
          child: TextField(
            onChanged: onQueryChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'بحث',
              hintText: 'ابحث بالاسم أو الرمز أو الوصف',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ),
        if (showStatusFilter)
          SizedBox(
            width: 220,
            child: DropdownButtonFormField<String>(
              initialValue: selectedStatus,
              decoration: const InputDecoration(
                labelText: 'الحالة',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: [
                const DropdownMenuItem(value: 'all', child: Text('كل الحالات')),
                for (final status in statuses)
                  DropdownMenuItem(
                    value: status,
                    child: Text(AdminPresentation.statusAr(status)),
                  ),
              ],
              onChanged: (value) => onStatusChanged(value ?? 'all'),
            ),
          ),
      ],
    );
  }
}

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.model});

  final _RecordModel model;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: Icon(model.icon),
        title: Text(model.title),
        subtitle: model.subtitle.isEmpty ? null : Text(model.subtitle),
        trailing: model.rawStatus == null
            ? const Icon(Icons.expand_more)
            : _StatusChip(rawStatus: model.rawStatus),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _InfoWrap(items: model.details),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.rawStatus});
  final Object? rawStatus;

  @override
  Widget build(BuildContext context) {
    final label = AdminPresentation.statusAr(rawStatus);
    return Chip(visualDensity: VisualDensity.compact, label: Text(label));
  }
}

class _InfoWrap extends StatelessWidget {
  const _InfoWrap({required this.items});
  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth >= 720
            ? (constraints.maxWidth - 24) / 3
            : constraints.maxWidth >= 420
            ? (constraints.maxWidth - 12) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).dividerColor.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.label,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.value ?? '—'}',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SectionFrame extends StatelessWidget {
  const _SectionFrame({
    required this.title,
    required this.child,
    this.subtitle,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context).width;
    final padding = viewport >= 1200
        ? 32.0
        : viewport >= 600
        ? 24.0
        : 16.0;
    return ListView(
      padding: EdgeInsets.all(padding),
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            Wrap(spacing: 8, runSpacing: 8, children: actions),
          ],
        ),
        const SizedBox(height: 20),
        child,
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 10),
            Text(message),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView(this.error);
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'تعذر تحميل البيانات. أعد المحاولة من زر التحديث.',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_RecordModel _seasonModel(Map<String, dynamic> row) {
  final year = row['hijri_year'];
  final gregorian = row['gregorian_year'];
  final bits = <String>[
    if ('${row['season_code'] ?? ''}'.isNotEmpty) '${row['season_code']}',
    if (year != null) '$year هـ',
    if (gregorian != null) '$gregorian م',
  ];
  return _RecordModel(
    row: row,
    icon: Icons.calendar_month_outlined,
    title: '${row['title_ar'] ?? row['season_code'] ?? 'موسم'}',
    subtitle: bits.join(' • '),
    rawStatus: '${row['status'] ?? ''}',
    details: [
      _InfoItem('نوع البيانات', AdminPresentation.syntheticSeasonLabel(row)),
      _InfoItem(
        'فتح التسجيل',
        AdminPresentation.dateTimeAr(row['registration_opens_at']),
      ),
      _InfoItem(
        'إغلاق التسجيل',
        AdminPresentation.dateTimeAr(row['registration_closes_at']),
      ),
      _InfoItem(
        'بدء العمليات',
        AdminPresentation.dateTimeAr(row['operations_start_at']),
      ),
      _InfoItem(
        'نهاية العمليات',
        AdminPresentation.dateTimeAr(row['operations_end_at']),
      ),
      _InfoItem('آخر تحديث', AdminPresentation.dateTimeAr(row['updated_at'])),
    ],
  );
}

_RecordModel _contentModel(Map<String, dynamic> row) {
  final body = '${row['body_ar'] ?? ''}'.trim();
  return _RecordModel(
    row: row,
    icon: _contentIcon('${row['content_type'] ?? ''}'),
    title: '${row['title_ar'] ?? row['slug'] ?? 'محتوى'}',
    subtitle: AdminPresentation.contentTypeAr(row['content_type']),
    rawStatus: '${row['status'] ?? ''}',
    details: [
      _InfoItem(
        'نوع المحتوى',
        AdminPresentation.contentTypeAr(row['content_type']),
      ),
      _InfoItem('جهة/مصدر الاعتماد', AdminPresentation.authorityLabel(row)),
      _InfoItem(
        'تاريخ النشر',
        AdminPresentation.dateTimeAr(row['published_at']),
      ),
      _InfoItem('المعرّف', row['slug'] ?? '—'),
      _InfoItem('ملخص المحتوى', body.isEmpty ? 'لا يوجد نص' : body),
      _InfoItem('آخر تحديث', AdminPresentation.dateTimeAr(row['updated_at'])),
    ],
  );
}

_RecordModel _notificationModel(Map<String, dynamic> row) {
  return _RecordModel(
    row: row,
    icon: Icons.notifications_outlined,
    title: '${row['title_ar'] ?? 'إشعار'}',
    subtitle: AdminPresentation.audienceAr(row['audience']),
    rawStatus: '${row['status'] ?? ''}',
    details: [
      _InfoItem(
        'الجمهور المستهدف',
        AdminPresentation.audienceAr(row['audience']),
      ),
      _InfoItem(
        'موعد الجدولة',
        AdminPresentation.dateTimeAr(row['scheduled_for']),
      ),
      _InfoItem('وقت النشر', AdminPresentation.dateTimeAr(row['published_at'])),
      _InfoItem('النص', row['body_ar'] ?? '—'),
      _InfoItem('آخر تحديث', AdminPresentation.dateTimeAr(row['updated_at'])),
    ],
  );
}

_RecordModel _auditModel(Map<String, dynamic> row) {
  final action = AdminPresentation.actionAr(row['action_key']);
  final entity = AdminPresentation.entityAr(row['entity_type']);
  return _RecordModel(
    row: row,
    icon: Icons.fact_check_outlined,
    title: action,
    subtitle: '$entity • ${AdminPresentation.dateTimeAr(row['created_at'])}',
    rawStatus: null,
    details: [
      _InfoItem('الكيان', entity),
      _InfoItem('معرّف الكيان', AdminPresentation.shortId(row['entity_id'])),
      _InfoItem(
        'المستخدم المنفذ',
        AdminPresentation.shortId(row['actor_user_id']),
      ),
      _InfoItem('معرّف الطلب', AdminPresentation.shortId(row['request_id'])),
      _InfoItem('وقت التنفيذ', AdminPresentation.dateTimeAr(row['created_at'])),
      _InfoItem(
        'توثيق التغيير',
        row['after_state'] == null
            ? 'لا توجد حالة لاحقة مسجلة'
            : 'محفوظ في سجل التدقيق',
      ),
    ],
  );
}

IconData _contentIcon(String type) {
  return switch (type) {
    'fatwa' => Icons.gavel_outlined,
    'guidance' => Icons.menu_book_outlined,
    'faq' => Icons.help_outline,
    'service' => Icons.room_service_outlined,
    'contact' => Icons.contact_phone_outlined,
    'banner' => Icons.campaign_outlined,
    _ => Icons.article_outlined,
  };
}

List<String> _adminRoleLabels(Map<String, dynamic> context) {
  final labels = <String>[];
  if (context['is_superuser'] == true) labels.add('مدير أعلى');
  final roles = context['roles'];
  if (roles is List) {
    for (final role in roles) {
      final label = AdminPresentation.roleAr(role);
      if (!labels.contains(label)) labels.add(label);
    }
  }
  return labels;
}

class _RecordModel {
  const _RecordModel({
    required this.row,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.rawStatus,
    required this.details,
  });

  final Map<String, dynamic> row;
  final IconData icon;
  final String title;
  final String subtitle;
  final String? rawStatus;
  final List<_InfoItem> details;

  String get searchableText => <String>[
    title,
    subtitle,
    if (rawStatus != null) AdminPresentation.statusAr(rawStatus),
    for (final item in details) '${item.label} ${item.value ?? ''}',
  ].join(' ');
}

class _InfoItem {
  const _InfoItem(this.label, this.value);
  final String label;
  final Object? value;
}

class _MetricDefinition {
  const _MetricDefinition(this.key, this.label, this.icon);
  final String key;
  final String label;
  final IconData icon;
}

class _AdminNavItem {
  const _AdminNavItem(this.label, this.icon);
  final String label;
  final IconData icon;
}
