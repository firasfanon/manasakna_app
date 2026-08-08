import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/munasakna_routes.dart';
import '../../../../app/theme/munasakna_theme.dart';
import '../../../../core/widgets/munasakna_bottom_nav.dart';
import '../../../nusuk_data/domain/models/journey_overview.dart';
import '../../../nusuk_data/domain/models/journey_step.dart';
import '../../../nusuk_data/presentation/providers/nusuk_providers.dart';

class JourneyPage extends ConsumerWidget {
  const JourneyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(journeyOverviewProvider);
    final stepsAsync = ref.watch(journeyStepsProvider);

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: const MunasaknaBottomNav(selectedIndex: 1),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFCF5), Color(0xFFFDF8EE), Color(0xFFFBF4E7)],
          ),
        ),
        child: SafeArea(
          child: overviewAsync.when(
            data: (overview) => stepsAsync.when(
              data: (steps) => _JourneyVisualContent(overview: overview, steps: steps),
              loading: () => const _CenteredLoader(),
              error: (error, stackTrace) => _JourneyError(message: 'تعذر تحميل مراحل الرحلة: $error'),
            ),
            loading: () => const _CenteredLoader(),
            error: (error, stackTrace) => _JourneyError(message: 'تعذر تحميل ملخص الرحلة: $error'),
          ),
        ),
      ),
    );
  }
}

class _JourneyVisualContent extends StatelessWidget {
  const _JourneyVisualContent({required this.overview, required this.steps});

  final JourneyOverview overview;
  final List<JourneyStep> steps;

  @override
  Widget build(BuildContext context) {
    final currentStep = steps.firstWhere((step) => step.isCurrent, orElse: () => steps.first);
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.only(bottom: 112),
      children: [
        _JourneyHeader(onBack: () => context.canPop() ? context.pop() : context.go(MunasaknaRoutes.home)),
        Transform.translate(
          offset: const Offset(0, -4),
          child: _JourneyStatusCard(overview: overview),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: _CurrentNextCard(currentStep: currentStep, overview: overview),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            'مراحل رحلة الحاج',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: MunasaknaTheme.deepHaramGreen,
                  fontWeight: FontWeight.w900,
                ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: _JourneyTimeline(steps: steps, onTap: (step) => _showDetails(context, step)),
        ),
        const SizedBox(height: 18),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 18),
          child: _ImportantNoticeCard(),
        ),
      ],
    );
  }

  void _showDetails(BuildContext context, JourneyStep step) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (sheetContext) => _StepDetailsSheet(step: step),
    );
  }
}

class _JourneyHeader extends StatelessWidget {
  const _JourneyHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF064B3E), Color(0xFF0B6A53)],
        ),
      ),
      child: Stack(
        children: [
          PositionedDirectional(
            top: 80,
            start: 48,
            child: Icon(Icons.mosque_rounded, size: 76, color: Colors.white.withValues(alpha: 0.08)),
          ),
          PositionedDirectional(
            top: 96,
            end: 50,
            child: Icon(Icons.mosque_rounded, size: 100, color: Colors.white.withValues(alpha: 0.08)),
          ),
          PositionedDirectional(
            top: 14,
            end: 18,
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 28),
              tooltip: 'عودة',
            ),
          ),
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  'رحلتي',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: Text(
                    'رحلة إيمانية\nتنظيم دقيق... وطمأنينة تامة',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          height: 1.55,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyStatusCard extends StatelessWidget {
  const _JourneyStatusCard({required this.overview});

  final JourneyOverview overview;

  @override
  Widget build(BuildContext context) {
    final progress = 0.65;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFEDE6D8)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 22, offset: const Offset(0, 12)),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 104,
            height: 104,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 96,
                  height: 96,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 9,
                    backgroundColor: const Color(0xFFE8ECE8),
                    color: MunasaknaTheme.haramGreen,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('65%', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: MunasaknaTheme.haramGreen, fontWeight: FontWeight.w900)),
                    Text('جاهز', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('حالة رحلتك', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: MunasaknaTheme.deepHaramGreen, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(
                  'أنت على الطريق الصحيح لاستكمال متطلبات رحلتك بنجاح، وفقك الله.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55, color: const Color(0xFF3E4F49), fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  overview.titleAr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.transparent, fontSize: 1, height: 0.01),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentNextCard extends StatelessWidget {
  const _CurrentNextCard({required this.currentStep, required this.overview});

  final JourneyStep currentStep;
  final JourneyOverview overview;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFEDE6D8)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.055), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          Expanded(child: _MiniStage(label: 'المرحلة الحالية', title: currentStep.titleAr, subtitle: currentStep.descriptionAr, icon: Icons.health_and_safety_rounded)),
          Container(width: 1, height: 60, color: const Color(0xFFECE5D8)),
          Expanded(child: _MiniStage(label: 'الخطوة التالية', title: 'إكمال التطعيمات', subtitle: 'الإلزامية', icon: Icons.vaccines_rounded, gold: true)),
        ],
      ),
    );
  }
}

class _MiniStage extends StatelessWidget {
  const _MiniStage({required this.label, required this.title, required this.subtitle, required this.icon, this.gold = false});

  final String label;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool gold;

  @override
  Widget build(BuildContext context) {
    final color = gold ? MunasaknaTheme.kiswahGold : MunasaknaTheme.haramGreen;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: const Color(0xFF7A817B), fontWeight: FontWeight.w800)),
          const SizedBox(height: 7),
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(color: color.withValues(alpha: 0.13), borderRadius: BorderRadius.circular(14)),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: MunasaknaTheme.deepHaramGreen, fontWeight: FontWeight.w900)),
                    Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: const Color(0xFF7A817B), fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _JourneyTimeline extends StatelessWidget {
  const _JourneyTimeline({required this.steps, required this.onTap});

  final List<JourneyStep> steps;
  final ValueChanged<JourneyStep> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFEDE6D8)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 18, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          for (var index = 0; index < steps.length; index++)
            _TimelineRow(
              index: index + 1,
              step: steps[index],
              isLast: index == steps.length - 1,
              onTap: () => onTap(steps[index]),
            ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.index, required this.step, required this.isLast, required this.onTap});

  final int index;
  final JourneyStep step;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final active = step.status == JourneyStepStatus.current || step.status == JourneyStepStatus.attention;
    final done = step.status == JourneyStepStatus.completed;
    final color = active ? MunasaknaTheme.haramGreen : done ? const Color(0xFF6BAA36) : const Color(0xFFCDD8D0);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Column(
              children: [
                Container(
                  width: active ? 38 : 34,
                  height: active ? 38 : 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? color : Colors.white,
                    border: Border.all(color: color, width: active ? 0 : 1.5),
                  ),
                  child: done
                      ? const Icon(Icons.check_rounded, color: Colors.white, size: 21)
                      : Text('$index', style: TextStyle(color: active ? Colors.white : color, fontWeight: FontWeight.w900)),
                ),
                if (!isLast) Container(width: 2, height: 42, color: const Color(0xFFDDE5DF)),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12, top: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.titleAr, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: MunasaknaTheme.deepHaramGreen, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(step.descriptionAr, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF7A817B), fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(Icons.chevron_left_rounded, color: Color(0xFF9BA59E)),
          ),
        ],
      ),
    );
  }
}

class _ImportantNoticeCard extends StatelessWidget {
  const _ImportantNoticeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(colors: [Color(0xFFFFF9EC), Color(0xFFFFFDF8)]),
        border: Border.all(color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.26)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: MunasaknaTheme.kiswahGold.withValues(alpha: 0.15), shape: BoxShape.circle),
            child: const Icon(Icons.notifications_active_outlined, color: MunasaknaTheme.kiswahGold),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('تنبيه مهم', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: MunasaknaTheme.deepHaramGreen, fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                Text('احرص على إكمال التطعيمات قبل 15 ذو القعدة لضمان قبول سفرك.', style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.55, color: const Color(0xFF616A64), fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepDetailsSheet extends StatelessWidget {
  const _StepDetailsSheet({required this.step});

  final JourneyStep step;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(step.titleAr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(step.descriptionAr, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.55)),
            const SizedBox(height: 14),
            for (final item in step.checklistItemsAr)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: MunasaknaTheme.haramGreen, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CenteredLoader extends StatelessWidget {
  const _CenteredLoader();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _JourneyError extends StatelessWidget {
  const _JourneyError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(padding: const EdgeInsets.all(24), child: Text(message, textAlign: TextAlign.center)));
  }
}
