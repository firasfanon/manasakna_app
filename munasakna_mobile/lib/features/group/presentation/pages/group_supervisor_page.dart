import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/info_section_card.dart';
import '../../../../core/widgets/munasakna_app_scaffold.dart';
import '../../../../core/widgets/munasakna_status_chip.dart';

class GroupSupervisorPage extends StatelessWidget {
  const GroupSupervisorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MunasaknaAppScaffold(
      title: 'مجموعتي والمشرف',
      headerIcon: Icons.groups_2_outlined,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const InfoSectionCard(
            title: 'بيانات مجموعة تجريبية',
            subtitle: 'هذه الصفحة تمهد لربط الحاج بالشركة، المجموعة، المشرف، المرشد، ونقاط التجمع من نظام نسك.',
            icon: Icons.groups_2_outlined,
            trailing: MunasaknaStatusChip(label: 'نسك لاحقًا', icon: Icons.cloud_queue_outlined),
            children: [
              Text('لا تعرض الصفحة بيانات حقيقية الآن. الهدف تثبيت تجربة الاستخدام قبل تفعيل تسجيل الدخول والربط بالسيرفر.'),
            ],
          ),
          const SizedBox(height: 12),
          _GroupIdentityCard(),
          const SizedBox(height: 12),
          for (final contact in _contacts) ...[
            _ContactRoleCard(contact: contact),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 2),
          InfoSectionCard(
            title: 'نقاط التجمع المتوقعة',
            icon: Icons.location_on_outlined,
            children: [
              for (final point in _meetingPoints) _PointRow(point),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(onPressed: () => context.push(MunasaknaRoutes.currentLocation), icon: const Icon(Icons.my_location_outlined), label: const Text('موقعي الحالي')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.contacts), icon: const Icon(Icons.call_outlined), label: const Text('هواتف ضرورية')),
                  OutlinedButton.icon(onPressed: () => context.push(MunasaknaRoutes.emergency), icon: const Icon(Icons.emergency_outlined), label: const Text('الطوارئ')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GroupIdentityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: MunasaknaTheme.sacredGradient(scheme),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: MunasaknaTheme.deepHaramGreen.withValues(alpha: 0.20), blurRadius: 18, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(width: 54, height: 54, decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.13), borderRadius: BorderRadius.circular(19)), child: const Icon(Icons.diversity_3_outlined, color: MunasaknaTheme.kiswahGold)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('مجموعة تجريبية - أ', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 5),
                    Text('الشركة والمرشد ونقطة التجمع ستأتي من نسك لاحقًا', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.78))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _WhiteBadge('رقم المجموعة: مؤقت'),
              _WhiteBadge('المخيم: لاحقًا'),
              _WhiteBadge('الحافلة: لاحقًا'),
            ],
          ),
        ],
      ),
    );
  }
}

class _WhiteBadge extends StatelessWidget {
  const _WhiteBadge(this.text);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.white.withValues(alpha: 0.18))),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
    );
  }
}

class _ContactRoleCard extends StatelessWidget {
  const _ContactRoleCard({required this.contact});
  final _ContactRole contact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(24), border: Border.all(color: contact.color.withValues(alpha: 0.20))),
      child: Row(
        children: [
          Container(width: 48, height: 48, decoration: BoxDecoration(color: contact.color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(17)), child: Icon(contact.icon, color: contact.color)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(contact.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(contact.description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.45)),
            ]),
          ),
          IconButton(onPressed: null, icon: Icon(contact.actionIcon, color: contact.color), tooltip: 'يتفعل بعد الربط'),
        ],
      ),
    );
  }
}

class _PointRow extends StatelessWidget {
  const _PointRow(this.point);
  final String point;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.place_outlined, size: 18, color: MunasaknaTheme.haramGreen),
          const SizedBox(width: 8),
          Expanded(child: Text(point)),
        ],
      ),
    );
  }
}

class _ContactRole {
  const _ContactRole({required this.title, required this.description, required this.icon, required this.actionIcon, required this.color});
  final String title;
  final String description;
  final IconData icon;
  final IconData actionIcon;
  final Color color;
}

const _contacts = [
  _ContactRole(title: 'مشرف المجموعة', description: 'مسؤول عن التنسيق الإداري والتفويج والمواعيد العامة.', icon: Icons.supervisor_account_outlined, actionIcon: Icons.call_outlined, color: MunasaknaTheme.haramGreen),
  _ContactRole(title: 'المرشد الشرعي', description: 'يوجه للأسئلة الشرعية العامة ويُحيل المسائل الحساسة إلى اللجنة.', icon: Icons.menu_book_outlined, actionIcon: Icons.question_answer_outlined, color: MunasaknaTheme.kiswahGold),
  _ContactRole(title: 'الدعم الميداني', description: 'للطوارئ، الضياع، الزحام، أو الحاجة إلى مساعدة عاجلة.', icon: Icons.support_agent_outlined, actionIcon: Icons.emergency_outlined, color: MunasaknaTheme.roseAlert),
];

const _meetingPoints = [
  'نقطة التجمع قبل السفر: تظهر من نسك حسب شركة الحاج.',
  'نقطة التجمع في منى: تظهر لاحقًا مع رقم المخيم والبوابة.',
  'نقطة طوارئ آمنة: يحددها المشرف حسب المكان والمرحلة.',
];
