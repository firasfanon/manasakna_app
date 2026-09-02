import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/munasakna_bottom_nav.dart';
import '../../application/manasikuna_1448_launch_controller.dart';
import '../../data/manasikuna_1448_synthetic_source.dart';
import '../../domain/manasikuna_1448_launch_models.dart';
import '../../domain/manasikuna_1448_models.dart';

class Manasikuna1448LaunchPage extends ConsumerStatefulWidget {
  const Manasikuna1448LaunchPage({super.key});

  @override
  ConsumerState<Manasikuna1448LaunchPage> createState() =>
      _Manasikuna1448LaunchPageState();
}

class _Manasikuna1448LaunchPageState
    extends ConsumerState<Manasikuna1448LaunchPage> {
  final TextEditingController _tokenController = TextEditingController();

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final launchAsync = ref.watch(manasikuna1448LaunchControllerProvider);

    return Scaffold(
      key: const ValueKey<String>('season1448-page'),
      bottomNavigationBar: const MunasaknaBottomNav(selectedIndex: 1),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFFFFFCF5),
              Color(0xFFFDF8EE),
              Color(0xFFFBF4E7),
            ],
          ),
        ),
        child: SafeArea(
          child: launchAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => _ErrorState(
              onRetry: () =>
                  ref.invalidate(manasikuna1448LaunchControllerProvider),
            ),
            data: (launchState) {
              if (!launchState.isActive) {
                return _ActivationView(
                  controller: _tokenController,
                  statusMessageCode: launchState.statusMessageCode,
                  onActivate: () => ref
                      .read(manasikuna1448LaunchControllerProvider.notifier)
                      .activate(_tokenController.text),
                );
              }

              return _ActiveJourneyView(
                launchState: launchState,
                onClear: () => ref
                    .read(manasikuna1448LaunchControllerProvider.notifier)
                    .clearActivation(),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ActivationView extends StatelessWidget {
  const _ActivationView({
    required this.controller,
    required this.statusMessageCode,
    required this.onActivate,
  });

  final TextEditingController controller;
  final String? statusMessageCode;
  final VoidCallback onActivate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 120),
      children: <Widget>[
        const _TopIdentityHeader(),
        const SizedBox(height: 14),
        const _TruthfulModeBanner(),
        const SizedBox(height: 18),
        Text(
          'فعّل رحلتك 1448',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: MunasaknaTheme.deepHaramGreen,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'أدخل رمز التفعيل الصادر من قناة مخوّلة. هذه الدفعة تستخدم رمزًا وبيانات تجريبية فقط، ولا تتصل بنسك أو بقاعدة حجاج حقيقية.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: const Color(0xFF52625C),
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 18),
        _SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                key: const ValueKey<String>('season1448-token-field'),
                controller: controller,
                textDirection: TextDirection.ltr,
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(
                  labelText: 'رمز التفعيل',
                  hintText: 'XXXX-XXXX-XXXX',
                  prefixIcon: Icon(Icons.key_rounded),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                key: const ValueKey<String>('season1448-activate-button'),
                onPressed: onActivate,
                icon: const Icon(Icons.verified_user_rounded),
                label: const Text('تفعيل الرحلة'),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                key: const ValueKey<String>('season1448-fill-demo-token'),
                onPressed: () {
                  controller.text = Manasikuna1448SyntheticSource.demoToken;
                },
                icon: const Icon(Icons.science_rounded),
                label: const Text('استخدام رمز تجريبي'),
              ),
              if (statusMessageCode != null) ...<Widget>[
                const SizedBox(height: 12),
                _StatusMessage(code: statusMessageCode!),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        _SurfaceCard(
          child: Column(
            children: <Widget>[
              Text(
                'معاينة QR التجريبي',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: MunasaknaTheme.deepHaramGreen,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 172,
                height: 172,
                child: QrImageView(
                  data: Manasikuna1448SyntheticSource.demoToken,
                  version: QrVersions.auto,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'الـQR يحمل Token اصطناعيًا فقط ولا يتضمن اسم الحاج أو رقم هوية أو أي بيانات شخصية.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      height: 1.5,
                      color: const Color(0xFF66736E),
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActiveJourneyView extends StatelessWidget {
  const _ActiveJourneyView({
    required this.launchState,
    required this.onClear,
  });

  final Manasikuna1448LaunchState launchState;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final session = launchState.session!;
    final now = DateTime.now().toUtc();
    final stale = session.isOperationalDataStaleAt(now);
    final next = session.nextScheduleItem(now);

    return ListView(
      key: const ValueKey<String>('season1448-active'),
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),
      children: <Widget>[
        const _TopIdentityHeader(),
        const SizedBox(height: 10),
        const _TruthfulModeBanner(),
        const SizedBox(height: 14),
        _PilgrimHero(
          session: session,
          restoredFromOffline: launchState.restoredFromOffline,
          stale: stale,
        ),
        const SizedBox(height: 14),
        if (next != null) _NextActionCard(item: next),
        if (next != null) const SizedBox(height: 14),
        _OperationalGrid(pack: session.pack),
        const SizedBox(height: 14),
        _QuickActions(),
        const SizedBox(height: 14),
        _ScheduleSection(schedule: session.pack.schedule),
        const SizedBox(height: 14),
        _MeetingPointsSection(points: session.pack.meetingPoints),
        const SizedBox(height: 14),
        _EmergencyContactsSection(
          contacts: session.pack.emergencyContacts,
        ),
        const SizedBox(height: 14),
        _OfflineStateCard(
          session: session,
          restoredFromOffline: launchState.restoredFromOffline,
          stale: stale,
        ),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          key: const ValueKey<String>('season1448-clear-activation'),
          onPressed: onClear,
          icon: const Icon(Icons.restart_alt_rounded),
          label: const Text('إلغاء التفعيل التجريبي من هذا الجهاز'),
        ),
      ],
    );
  }
}

class _TopIdentityHeader extends StatelessWidget {
  const _TopIdentityHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton.filledTonal(
          onPressed: () => context.go(MunasaknaRoutes.home),
          icon: const Icon(Icons.home_rounded),
          tooltip: 'الرئيسية',
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: <Widget>[
              Text(
                'رحلتي 1448',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: MunasaknaTheme.deepHaramGreen,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              Text(
                'الرفيق التشغيلي المستقل',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF60716A),
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 50),
      ],
    );
  }
}

class _TruthfulModeBanner extends StatelessWidget {
  const _TruthfulModeBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey<String>('season1448-truthful-mode-banner'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEBCB7A)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.science_rounded, color: Color(0xFF8D6512)),
          SizedBox(width: 9),
          Expanded(
            child: Text(
              'وضع تجريبي محلي: لا اتصال بنسك، لا بيانات حجاج حقيقية، ولا معاملات رسمية. يعمل هذا المسار Offline-first ببيانات Synthetic فقط.',
              style: TextStyle(
                color: Color(0xFF6D5016),
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PilgrimHero extends StatelessWidget {
  const _PilgrimHero({
    required this.session,
    required this.restoredFromOffline,
    required this.stale,
  });

  final Manasikuna1448LaunchSession session;
  final bool restoredFromOffline;
  final bool stale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: <Color>[
            MunasaknaTheme.deepHaramGreen,
            MunasaknaTheme.haramGreen,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _Pill(
                icon: Icons.check_circle_rounded,
                label: 'الحملة مفعلة محليًا',
              ),
              if (restoredFromOffline)
                const _Pill(
                  key: ValueKey<String>('season1448-offline-chip'),
                  icon: Icons.offline_bolt_rounded,
                  label: 'مستعاد من الجهاز',
                ),
              if (stale)
                const _Pill(
                  icon: Icons.schedule_rounded,
                  label: 'تحديث البيانات مطلوب',
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            session.profile.fullNameAr,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            session.pack.campaignNameAr,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'مرجع تشغيلي: ${session.profile.officialReference}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.78),
                ),
          ),
        ],
      ),
    );
  }
}

class _NextActionCard extends StatelessWidget {
  const _NextActionCard({required this.item});

  final CampaignScheduleItem item;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy/MM/dd  HH:mm');
    return _SurfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: MunasaknaTheme.haramGreen.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.upcoming_rounded,
              color: MunasaknaTheme.haramGreen,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'الحدث القادم',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: const Color(0xFF67746E),
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.titleAr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: MunasaknaTheme.deepHaramGreen,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 4),
                Text(formatter.format(item.startsAt.toLocal())),
                if (item.notesAr != null) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    item.notesAr!,
                    style: const TextStyle(
                      color: Color(0xFF67746E),
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OperationalGrid extends StatelessWidget {
  const _OperationalGrid({required this.pack});

  final CampaignOperationalPack pack;

  @override
  Widget build(BuildContext context) {
    final items = <_OperationalItem>[
      _OperationalItem(
        icon: Icons.supervisor_account_rounded,
        title: 'المشرف',
        value: pack.supervisor?.nameAr ?? 'غير متاح',
      ),
      _OperationalItem(
        icon: Icons.hotel_rounded,
        title: 'السكن',
        value: pack.hotelNameAr ?? 'غير متاح',
      ),
      _OperationalItem(
        icon: Icons.directions_bus_rounded,
        title: 'النقل',
        value: pack.transportLabelAr ?? 'غير متاح',
      ),
      _OperationalItem(
        icon: Icons.campaign_rounded,
        title: 'المجموعة',
        value: pack.groupReference ?? 'غير متاح',
      ),
      _OperationalItem(
        icon: Icons.location_city_rounded,
        title: 'منى',
        value: pack.minaCampAr ?? 'غير متاح',
      ),
      _OperationalItem(
        icon: Icons.landscape_rounded,
        title: 'عرفات',
        value: pack.arafatCampAr ?? 'غير متاح',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1000
            ? 3
            : width >= 620
                ? 2
                : 1;

        return GridView.builder(
          key: const ValueKey<String>('season1448-operational-grid'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            mainAxisExtent: 104,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return _SurfaceCard(
              padding: const EdgeInsets.all(13),
              child: Row(
                children: <Widget>[
                  Icon(item.icon, color: MunasaknaTheme.haramGreen),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.title,
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: const Color(0xFF718079),
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.value,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: MunasaknaTheme.deepHaramGreen,
                                    fontWeight: FontWeight.w900,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = <_QuickAction>[
      _QuickAction(
        'المشرف',
        Icons.groups_rounded,
        MunasaknaRoutes.groupSupervisor,
      ),
      _QuickAction(
        'السكن والنقل',
        Icons.hotel_rounded,
        MunasaknaRoutes.accommodationTransport,
      ),
      _QuickAction(
        'الجدول',
        Icons.event_note_rounded,
        MunasaknaRoutes.hajjSchedule,
      ),
      _QuickAction(
        'الطوارئ',
        Icons.emergency_rounded,
        MunasaknaRoutes.emergency,
      ),
      _QuickAction(
        'الموقع',
        Icons.location_on_rounded,
        MunasaknaRoutes.currentLocation,
      ),
    ];

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionTitle(title: 'وصول سريع'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: actions
                .map(
                  (item) => ActionChip(
                    avatar: Icon(item.icon, size: 18),
                    label: Text(item.label),
                    onPressed: () => context.push(item.route),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _ScheduleSection extends StatelessWidget {
  const _ScheduleSection({required this.schedule});

  final List<CampaignScheduleItem> schedule;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy/MM/dd  HH:mm');
    final sorted = schedule.toList(growable: false)
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));

    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionTitle(title: 'الجدول التشغيلي'),
          const SizedBox(height: 8),
          for (final item in sorted)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                child: Icon(Icons.schedule_rounded),
              ),
              title: Text(
                item.titleAr,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                '${formatter.format(item.startsAt.toLocal())}\n${item.notesAr ?? ''}',
              ),
              isThreeLine: item.notesAr != null,
            ),
        ],
      ),
    );
  }
}

class _MeetingPointsSection extends StatelessWidget {
  const _MeetingPointsSection({required this.points});

  final List<CampaignMeetingPoint> points;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionTitle(title: 'نقاط التجمع'),
          const SizedBox(height: 8),
          for (final point in points)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.location_on_rounded,
                color: MunasaknaTheme.haramGreen,
              ),
              title: Text(
                point.labelAr,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text(
                point.descriptionAr,
                style: const TextStyle(height: 1.4),
              ),
              trailing: point.latitude != null && point.longitude != null
                  ? IconButton(
                      onPressed: () =>
                          context.push(MunasaknaRoutes.currentLocation),
                      icon: const Icon(Icons.map_rounded),
                      tooltip: 'فتح صفحة الموقع',
                    )
                  : null,
            ),
        ],
      ),
    );
  }
}

class _EmergencyContactsSection extends StatelessWidget {
  const _EmergencyContactsSection({required this.contacts});

  final List<OperationalContact> contacts;

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionTitle(title: 'جهات الطوارئ'),
          const SizedBox(height: 8),
          for (final contact in contacts)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.phone_in_talk_rounded,
                color: Color(0xFFB3261E),
              ),
              title: Text(
                contact.roleAr,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              subtitle: Text('${contact.nameAr} — ${contact.phone}'),
              trailing: IconButton(
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: contact.phone),
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تم نسخ رقم الاتصال'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.copy_rounded),
                tooltip: 'نسخ الرقم',
              ),
            ),
        ],
      ),
    );
  }
}

class _OfflineStateCard extends StatelessWidget {
  const _OfflineStateCard({
    required this.session,
    required this.restoredFromOffline,
    required this.stale,
  });

  final Manasikuna1448LaunchSession session;
  final bool restoredFromOffline;
  final bool stale;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('yyyy/MM/dd  HH:mm');
    return _SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _SectionTitle(title: 'حالة Offline-first'),
          const SizedBox(height: 10),
          Text(
            restoredFromOffline
                ? 'تمت استعادة آخر نسخة صالحة محفوظة على هذا الجهاز.'
                : 'تم حفظ هذه الرحلة محليًا لتبقى متاحة عند انقطاع الشبكة.',
            style: const TextStyle(height: 1.5),
          ),
          const SizedBox(height: 7),
          Text(
            'آخر تحديث للحزمة: ${formatter.format(session.pack.updatedAt.toLocal())}',
          ),
          Text('Source revision: ${session.profile.sourceRevision}'),
          const SizedBox(height: 7),
          Text(
            stale
                ? 'تنبيه: النسخة المحلية أقدم من نافذة الحداثة المفضلة وتحتاج تحديثًا من مصدر مخوّل عند توفر الاتصال.'
                : 'النسخة المحلية ضمن نافذة الحداثة الحالية.',
            style: TextStyle(
              color: stale ? const Color(0xFF9A5B00) : const Color(0xFF1B6B42),
              fontWeight: FontWeight.w800,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final text = switch (code) {
      'activation_token_invalid' => 'رمز التفعيل غير صالح.',
      'activation_failed' => 'تعذر تفعيل الرحلة.',
      'offline_activation_expired' =>
        'انتهت صلاحية التفعيل المحلي، ويلزم رمز صالح جديد.',
      'activation_cleared' => 'تم حذف التفعيل المحلي من هذا الجهاز.',
      _ => 'الحالة: $code',
    };

    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Color(0xFF9D2F2F),
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline_rounded, size: 48),
            const SizedBox(height: 12),
            const Text(
              'تعذر تحميل حالة رحلة 1448 المحلية.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  const _SurfaceCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEDE6D8)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: MunasaknaTheme.deepHaramGreen,
            fontWeight: FontWeight.w900,
          ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    super.key,
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _OperationalItem {
  const _OperationalItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;
}

class _QuickAction {
  const _QuickAction(this.label, this.icon, this.route);

  final String label;
  final IconData icon;
  final String route;
}
