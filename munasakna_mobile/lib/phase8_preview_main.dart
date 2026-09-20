import 'package:flutter/material.dart';

import 'features/journey_contract/domain/journey_context.dart';
import 'features/unified_journey/data/phase8_journey_catalog.dart';
import 'features/unified_journey/domain/unified_journey_resolution.dart';
import 'features/unified_journey/presentation/unified_journey_switcher.dart';

const _previewRitual = String.fromEnvironment(
  'PHASE8_PREVIEW_RITUAL',
  defaultValue: 'hajj',
);

const _offlineUmrah = bool.fromEnvironment(
  'PHASE8_PREVIEW_OFFLINE_UMRAH',
  defaultValue: false,
);

void main() {
  runApp(const Phase8PreviewApp());
}

class Phase8PreviewApp extends StatefulWidget {
  const Phase8PreviewApp({super.key});

  @override
  State<Phase8PreviewApp> createState() => _Phase8PreviewAppState();
}

class _Phase8PreviewAppState extends State<Phase8PreviewApp> {
  late JourneyType selectedType =
      _previewRitual == 'umrah' ? JourneyType.umrah : JourneyType.hajj;

  Future<UnifiedJourneyResolution> _load() async {
    final contexts = await const LocalPhase8JourneyCatalog(
      umrahFreshness: _offlineUmrah
          ? JourneyFreshness.offlineSnapshot
          : JourneyFreshness.fresh,
    ).loadEligibleJourneys();

    return const UnifiedJourneyResolver().resolve(
      contexts,
      preferredType: selectedType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مناسكنا — Phase 8 UAT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0B6A53),
        ),
        useMaterial3: true,
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFFFFCF5),
          appBar: AppBar(
            title: const Text('مناسكنا — تجربة الرحلة الموحدة'),
          ),
          body: FutureBuilder<UnifiedJourneyResolution>(
            future: _load(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    'تعذر تحديد مصدر الرحلة بأمان.',
                    textAlign: TextAlign.center,
                  ),
                );
              }
              final resolution = snapshot.data;
              if (resolution == null) {
                return const Center(child: CircularProgressIndicator());
              }
              final selected = resolution.selected;
              return ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Text(
                    'تجربة موحدة للحاج والمعتمر',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF064B3E),
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'الواجهة موحدة، لكن مصدر السلطة والبيانات يبقى واضحًا ومنفصلًا.',
                  ),
                  const SizedBox(height: 18),
                  UnifiedJourneySwitcherView(
                    resolution: resolution,
                    onSelect: (type) {
                      setState(() {
                        selectedType = type;
                      });
                    },
                  ),
                  if (selected != null) ...[
                    const SizedBox(height: 18),
                    _PreviewJourneyCard(candidate: selected),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PreviewJourneyCard extends StatelessWidget {
  const _PreviewJourneyCard({required this.candidate});

  final UnifiedJourneyCandidate candidate;

  @override
  Widget build(BuildContext context) {
    final isHajj = candidate.type == JourneyType.hajj;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isHajj ? 'وضع رحلة الحاج' : 'وضع رحلة المعتمر',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 10),
            Text(candidate.sourceLabelAr),
            const SizedBox(height: 8),
            Text(candidate.freshnessLabelAr),
            const Divider(height: 28),
            Text(
              isHajj
                  ? 'الحالة الرسمية للحج تبقى تحت سلطة الجهة الحكومية، بينما تظهر البيانات التشغيلية المفوضة دون تحويلها إلى سلطة سيادية.'
                  : 'بيانات العمرة تشغيلية من الشركة المنظمة، ولا تنشئ أهلية أو قرعة أو حصة أو حالة حج رسمية.',
            ),
            const SizedBox(height: 14),
            const Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('الإرشادات')),
                Chip(label: Text('الوثائق')),
                Chip(label: Text('الإقامة')),
                Chip(label: Text('النقل')),
                Chip(label: Text('الدعم')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
