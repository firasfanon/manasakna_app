import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../journey_contract/domain/journey_context.dart';
import '../domain/unified_journey_resolution.dart';
import 'unified_journey_providers.dart';

class UnifiedJourneySwitcherCard extends ConsumerWidget {
  const UnifiedJourneySwitcherCard({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resolution = ref.watch(unifiedJourneyResolutionProvider);

    return resolution.when(
      loading: () => const _SafeLoadingCard(),
      error: (_, __) => const _SafeAuthorityErrorCard(),
      data: (data) => UnifiedJourneySwitcherView(
        resolution: data,
        compact: compact,
        onSelect: (type) => selectUnifiedJourney(ref, type),
      ),
    );
  }
}

class UnifiedJourneySwitcherView extends StatelessWidget {
  const UnifiedJourneySwitcherView({
    required this.resolution,
    required this.onSelect,
    this.compact = false,
    super.key,
  });

  final UnifiedJourneyResolution resolution;
  final ValueChanged<JourneyType> onSelect;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final selected = resolution.selected;

    return Semantics(
      container: true,
      label: 'اختيار الرحلة النشطة',
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(compact ? 20 : 26),
          side: const BorderSide(color: Color(0xFFE9E2D5)),
        ),
        child: Padding(
          padding: EdgeInsets.all(compact ? 14 : 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.route_rounded,
                    color: Color(0xFF0B6A53),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          compact ? 'رحلتك النشطة' : 'رحلاتي',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFF064B3E),
                                  ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          resolution.hasMultipleJourneys
                              ? 'يمكنك الانتقال بوضوح بين رحلة الحج ورحلة العمرة.'
                              : 'تم تحديد الرحلة المتاحة تلقائيًا.',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    height: 1.45,
                                    color: const Color(0xFF66736E),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final candidate in resolution.candidates)
                    _JourneyChoiceChip(
                      candidate: candidate,
                      selected: selected?.id == candidate.id,
                      onTap: () => onSelect(candidate.type),
                    ),
                ],
              ),
              if (selected != null) ...[
                const SizedBox(height: 14),
                _JourneyAuthoritySummary(candidate: selected, compact: compact),
              ] else ...[
                const SizedBox(height: 14),
                const _SelectionRequiredNotice(),
              ],
              if (!compact && resolution.hasMultipleJourneys) ...[
                const SizedBox(height: 12),
                Text(
                  'سجل الرحلات المتاحة: ${resolution.candidates.length}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF7C6A45),
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneyChoiceChip extends StatelessWidget {
  const _JourneyChoiceChip({
    required this.candidate,
    required this.selected,
    required this.onTap,
  });

  final UnifiedJourneyCandidate candidate;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = candidate.type == JourneyType.hajj
        ? Icons.mosque_rounded
        : Icons.luggage;
    final color = selected ? const Color(0xFF0B6A53) : const Color(0xFFF7F2E8);

    return Semantics(
      button: true,
      selected: selected,
      label: '${candidate.modeLabelAr} — ${candidate.sourceLabelAr}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: selected
                    ? const Color(0xFF0B6A53)
                    : const Color(0xFFE6DDCD),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected ? Colors.white : const Color(0xFF6A5C42),
                ),
                const SizedBox(width: 8),
                Text(
                  candidate.modeLabelAr,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: selected ? Colors.white : const Color(0xFF433A2B),
                  ),
                ),
                const SizedBox(width: 7),
                if (selected)
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 17,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _JourneyAuthoritySummary extends StatelessWidget {
  const _JourneyAuthoritySummary({
    required this.candidate,
    required this.compact,
  });

  final UnifiedJourneyCandidate candidate;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final official = candidate.isOfficialHajj;
    final icon = official ? Icons.verified_rounded : Icons.apartment_rounded;
    final accent = official ? const Color(0xFF0B6A53) : const Color(0xFF9A6B20);

    return Container(
      padding: EdgeInsets.all(compact ? 12 : 14),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  candidate.sourceLabelAr,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: accent,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${candidate.authorityBadgeAr} • ${candidate.freshnessLabelAr}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF5C665F),
                        height: 1.4,
                      ),
                ),
                if (!compact) ...[
                  const SizedBox(height: 6),
                  Text(
                    candidate.isCommercialUmrah
                        ? 'هذه معلومات تشغيلية للمعتمر من الشركة المنظمة، وليست حالة حج رسمية.'
                        : 'المعلومات الرسمية المرتبطة بالحج تبقى تحت سلطة الجهة الحكومية.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF5C665F),
                          height: 1.45,
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

class _SelectionRequiredNotice extends StatelessWidget {
  const _SelectionRequiredNotice();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Text(
        'تعذر تحديد رحلة واحدة دون غموض. اختر الرحلة التي تريد عرضها.',
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _SafeAuthorityErrorCard extends StatelessWidget {
  const _SafeAuthorityErrorCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.shield_outlined, color: Color(0xFF9A6B20)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'تعذر تحديد مصدر الرحلة بأمان. لم يتم عرض بيانات قد تسبب التباسًا في الصلاحيات.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SafeLoadingCard extends StatelessWidget {
  const _SafeLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'جاري تحديد الرحلة المتاحة...',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
