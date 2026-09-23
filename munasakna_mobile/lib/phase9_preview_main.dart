import 'package:flutter/material.dart';

import 'features/cross_plane_gateway/data/phase9_cross_plane_journey_catalog.dart';
import 'features/journey_contract/domain/journey_context.dart';
import 'features/unified_journey/domain/unified_journey_resolution.dart';
import 'features/unified_journey/presentation/unified_journey_switcher.dart';

void main() => runApp(const Phase9PreviewApp());

class Phase9PreviewApp extends StatefulWidget {
  const Phase9PreviewApp({super.key});

  @override
  State<Phase9PreviewApp> createState() => _Phase9PreviewAppState();
}

class _Phase9PreviewAppState extends State<Phase9PreviewApp> {
  JourneyType selectedType = JourneyType.umrah;

  Future<UnifiedJourneyResolution> _load() async {
    final contexts =
        await Phase9CrossPlaneJourneyCatalog().loadEligibleJourneys();
    return const UnifiedJourneyResolver().resolve(
      contexts,
      preferredType: selectedType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مناسكنا — Phase 9 G9',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B6A53)),
        useMaterial3: true,
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFFFFCF5),
          appBar: AppBar(title: const Text('مناسكنا — بوابة التكامل المحكومة')),
          body: FutureBuilder<UnifiedJourneyResolution>(
            future: _load(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                    child: Text('تعذر تحميل إسقاط الرحلة بأمان.'));
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
                    'Phase 9 — تكامل دون دمج السلطات',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: const Color(0xFF064B3E),
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'تصل بيانات العمرة عبر عقد محدود، بينما تبقى بيانات الحج الرسمية تحت مصدرها الحكومي.',
                  ),
                  const SizedBox(height: 18),
                  UnifiedJourneySwitcherView(
                    resolution: resolution,
                    onSelect: (type) => setState(() => selectedType = type),
                  ),
                  if (selected != null) ...[
                    const SizedBox(height: 18),
                    _GatewayPreviewCard(candidate: selected),
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

class _GatewayPreviewCard extends StatelessWidget {
  const _GatewayPreviewCard({required this.candidate});

  final UnifiedJourneyCandidate candidate;

  @override
  Widget build(BuildContext context) {
    final isUmrah = candidate.type == JourneyType.umrah;
    final delivered =
        candidate.context.travelerContext['cross_plane_delivery'] == true;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isUmrah ? 'رحلة العمرة' : 'رحلة الحج',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(candidate.sourceLabelAr),
            const SizedBox(height: 8),
            Text(candidate.freshnessLabelAr),
            const Divider(height: 28),
            Text(
              isUmrah
                  ? 'إسقاط بيانات المسافر عبر بوابة Phase 9؛ لا يوجد وصول مباشر إلى قاعدة بيانات الشركة.'
                  : 'المصدر الحكومي للحج مستقل عن بوابة العمرة التجارية.',
            ),
            if (isUmrah) ...[
              const SizedBox(height: 12),
              Chip(
                label: Text(
                  delivered
                      ? 'Cross-plane projection: فعال تجريبيًا'
                      : 'Cross-plane projection: غير فعال',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
