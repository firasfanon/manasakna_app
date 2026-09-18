import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/features/nusuk_data/data/demo_nusuk_repository.dart';

void main() {
  test('Hajj journey preserves government-led coordination model', () async {
    const repository = DemoNusukRepository(ritualPath: 'hajj');
    final overview = await repository.getJourneyOverview();
    final steps = await repository.getJourneySteps();
    expect(overview.subtitleAr, contains('الإشراف الحكومي'));
    expect(steps.any((step) => step.titleAr.contains('مناسك الحج')), isTrue);
    expect(steps.any((step) => step.stageLabelAr == 'أثناء الحج'), isTrue);
  });

  test('Umrah journey is company-led and has complete ritual lifecycle', () async {
    const repository = DemoNusukRepository(ritualPath: 'umrah');
    final overview = await repository.getJourneyOverview();
    final steps = await repository.getJourneySteps();
    expect(overview.titleAr, contains('المعتمر'));
    expect(overview.subtitleAr, contains('الشركة المنظمة'));
    expect(steps.map((step) => step.id), containsAll(<String>['booking_documents','readiness','miqat_ihram','tawaf','sai','halq','return_review']));
    expect(steps.any((step) => step.stageLabelAr == 'أثناء العمرة'), isTrue);
  });
}
