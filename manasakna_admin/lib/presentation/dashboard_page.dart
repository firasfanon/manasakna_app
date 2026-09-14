import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/admin_environment.dart';
import '../data/admin_repository.dart';

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
    final body = _buildSection();
    return Scaffold(
      appBar: AppBar(
        title: const Text(AdminEnvironment.productNameAr),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Chip(
                avatar: const Icon(Icons.science_outlined, size: 18),
                label: const Text(AdminEnvironment.environmentLabel),
              ),
            ),
          ),
          IconButton(
            tooltip: 'تحديث',
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
              width: 250,
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                child: _navigation(closeOnTap: false),
              ),
            ),
          Expanded(child: body),
        ],
      ),
    );
  }

  Widget _navigation({required bool closeOnTap}) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          const ListTile(
            leading: Icon(Icons.mosque_outlined),
            title: Text('مناسكنا 1448'),
            subtitle: Text('Standalone Admin V1'),
          ),
          const Divider(),
          for (var i = 0; i < _items.length; i++)
            ListTile(
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
            child: Text(
              'V1 مغلق على البيانات الاصطناعية فقط. نسك غير مطلوب لهذه المرحلة.',
              style: TextStyle(fontSize: 12),
            ),
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
      1 => _ListSection(
        key: ValueKey('seasons-$_refreshEpoch'),
        title: 'المواسم',
        future: widget.repository.seasons(),
        actionLabel: 'تهيئة موسم 1448',
        onAction: _seedSeason1448,
      ),
      2 => _LotterySection(
        key: ValueKey('lottery-$_refreshEpoch'),
        repository: widget.repository,
        onChanged: _refresh,
      ),
      3 => _ListSection(
        key: ValueKey('campaigns-$_refreshEpoch'),
        title: 'الحملات والمجموعات',
        future: widget.repository.campaigns(),
      ),
      4 => _ListSection(
        key: ValueKey('content-$_refreshEpoch'),
        title: 'المحتوى والفتاوى',
        future: widget.repository.content(),
        actionLabel: 'إضافة محتوى تجريبي',
        onAction: _seedContent,
      ),
      5 => _ListSection(
        key: ValueKey('notifications-$_refreshEpoch'),
        title: 'الإشعارات',
        future: widget.repository.notifications(),
        actionLabel: 'إضافة إشعار تجريبي',
        onAction: _seedNotification,
      ),
      _ => _ListSection(
        key: ValueKey('audit-$_refreshEpoch'),
        title: 'سجل التدقيق',
        future: widget.repository.audit(),
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
    return FutureBuilder<Map<String, dynamic>>(
      future: repository.dashboard(),
      builder: (context, snapshot) {
        return _SectionFrame(
          title: 'لوحة المتابعة',
          subtitle: 'حالة التشغيل المستقل لمناسكنا — بيانات اصطناعية فقط',
          child: snapshot.connectionState != ConnectionState.done
              ? const Center(child: CircularProgressIndicator())
              : snapshot.hasError
              ? _ErrorView(snapshot.error)
              : _DashboardCards(
                  data: snapshot.data ?? const {},
                  adminContext: adminContext,
                ),
        );
      },
    );
  }
}

class _DashboardCards extends StatelessWidget {
  const _DashboardCards({required this.data, required this.adminContext});

  final Map<String, dynamic> data;
  final Map<String, dynamic> adminContext;

  @override
  Widget build(BuildContext context) {
    final entries = <MapEntry<String, dynamic>>[
      ...data.entries,
      MapEntry('admin_context', adminContext),
    ];
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: entries
          .map((entry) {
            return SizedBox(
              width: 260,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        const JsonEncoder.withIndent('  ').convert(entry.value),
                      ),
                    ],
                  ),
                ),
              ),
            );
          })
          .toList(growable: false),
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
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final result = await widget.repository.seedSyntheticFixture();
      if (!mounted) return;
      setState(
        () => _message = const JsonEncoder.withIndent('  ').convert(result),
      );
      widget.onChanged();
    } catch (error) {
      if (mounted) setState(() => _message = 'ERROR: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _runSyntheticE2E() async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final result = await widget.repository.runSyntheticE2E();
      if (!mounted) return;
      setState(
        () => _message = const JsonEncoder.withIndent('  ').convert(result),
      );
      widget.onChanged();
    } catch (error) {
      if (mounted) setState(() => _message = 'E2E ERROR: $error');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _SectionFrame(
      title: 'القرعة والأهلية',
      subtitle:
          'V1 يمنع البيانات الحقيقية ويستخدم Fixture اصطناعيًا من 12 حالة.',
      actions: [
        FilledButton.icon(
          onPressed: _busy ? null : _seedFixture,
          icon: const Icon(Icons.science_outlined),
          label: Text(_busy ? 'جارٍ التنفيذ…' : 'إنشاء وتشغيل عينة 12 حالة'),
        ),
        OutlinedButton.icon(
          onPressed: _busy ? null : _runSyntheticE2E,
          icon: const Icon(Icons.verified_outlined),
          label: const Text('E2E: القرعة ← المجموعة ← التفعيل'),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
            builder: (context, snapshot) => _FutureRows(snapshot: snapshot),
          ),
        ],
      ),
    );
  }
}

class _ListSection extends StatelessWidget {
  const _ListSection({
    super.key,
    required this.title,
    required this.future,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final Future<List<Map<String, dynamic>>> future;
  final String? actionLabel;
  final Future<void> Function()? onAction;
  @override
  Widget build(BuildContext context) {
    return _SectionFrame(
      title: title,
      actions: [
        if (actionLabel != null && onAction != null)
          FilledButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.add),
            label: Text(actionLabel!),
          ),
      ],
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: future,
        builder: (context, snapshot) => _FutureRows(snapshot: snapshot),
      ),
    );
  }
}

class _FutureRows extends StatelessWidget {
  const _FutureRows({required this.snapshot});
  final AsyncSnapshot<List<Map<String, dynamic>>> snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.connectionState != ConnectionState.done) {
      return const Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) return _ErrorView(snapshot.error);
    final rows = snapshot.data ?? const <Map<String, dynamic>>[];
    if (rows.isEmpty) {
      return const Center(child: Text('لا توجد سجلات بعد.'));
    }
    return Column(
      children: rows
          .map((row) {
            return Card(
              child: ExpansionTile(
                title: Text(_rowTitle(row)),
                subtitle: Text(_rowSubtitle(row)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SelectableText(
                        const JsonEncoder.withIndent('  ').convert(row),
                      ),
                    ),
                  ),
                ],
              ),
            );
          })
          .toList(growable: false),
    );
  }

  static String _rowTitle(Map<String, dynamic> row) =>
      '${row['name_ar'] ?? row['title_ar'] ?? row['season_code'] ?? row['round_code'] ?? row['campaign_code'] ?? row['id'] ?? 'سجل'}';

  static String _rowSubtitle(Map<String, dynamic> row) =>
      '${row['status'] ?? row['content_type'] ?? row['created_at'] ?? ''}';
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
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(subtitle!),
                ],
              ],
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

class _ErrorView extends StatelessWidget {
  const _ErrorView(this.error);
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Text(
          'تعذر تحميل البيانات: $error',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}

class _AdminNavItem {
  const _AdminNavItem(this.label, this.icon);
  final String label;
  final IconData icon;
}
