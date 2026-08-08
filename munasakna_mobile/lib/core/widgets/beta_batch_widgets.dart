import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/munasakna_theme.dart';
import 'munasakna_status_chip.dart';

class BetaBatchSummaryCard extends StatelessWidget {
  const BetaBatchSummaryCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.status,
    this.color = MunasaknaTheme.haramGreen,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            color.withValues(alpha: 0.16),
            scheme.surface,
            MunasaknaTheme.kiswahGold.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.22)),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (status != null) ...[
                  MunasaknaStatusChip(label: status!, icon: Icons.verified_outlined),
                  const SizedBox(height: 8),
                ],
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant, height: 1.55),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BetaChecklistTile extends StatelessWidget {
  const BetaChecklistTile({
    super.key,
    required this.title,
    required this.description,
    this.status,
    this.owner,
    this.icon,
    this.color = MunasaknaTheme.haramGreen,
    this.closed = false,
  });

  final String title;
  final String description;
  final String? status;
  final String? owner;
  final IconData? icon;
  final Color color;
  final bool closed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? (closed ? Icons.check_circle_outline : Icons.pending_actions_outlined), color: closed ? color : MunasaknaTheme.kiswahGold),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(description, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant, height: 1.45)),
                if (status != null || owner != null) ...[
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (status != null) MunasaknaStatusChip(label: status!, icon: Icons.info_outline),
                      if (owner != null) MunasaknaStatusChip(label: owner!, icon: Icons.person_outline),
                    ],
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

class BetaRouteTile extends StatelessWidget {
  const BetaRouteTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
    this.color = MunasaknaTheme.haramGreen,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String route;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: color.withValues(alpha: 0.18)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_left_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BetaBulletList extends StatelessWidget {
  const BetaBulletList({super.key, required this.items, this.icon = Icons.check_circle_outline});

  final List<String> items;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: scheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(item, style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
