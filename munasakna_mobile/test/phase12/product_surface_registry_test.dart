import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/app/config/munasakna_environment.dart';
import 'package:munasakna_mobile/app/router/munasakna_router.dart';
import 'package:munasakna_mobile/app/router/munasakna_routes.dart';
import 'package:munasakna_mobile/features/productization/domain/phase12_product_surface_registry.dart';

void main() {
  test('all Phase12 core surfaces have explicit truthful classification', () {
    expect(phase12CoreProductSurfaces.length, greaterThanOrEqualTo(13));
    expect(phase12CoreSurfacesTruthfullyClassified, isTrue);
    expect(
      phase12CoreProductSurfaces
          .where((surface) => surface.state == ProductSurfaceState.deferred)
          .every((surface) => surface.truthNote.contains('مؤجل')),
      isTrue,
    );
  });

  test('internal engineering tools are disabled by default', () {
    expect(MunasaknaEnvironment.internalToolsEnabled, isFalse);
  });

  test('router protects engineering and beta routes behind internal-tools flag',
      () {
    final source =
        File('lib/app/router/munasakna_router.dart').readAsStringSync();

    expect(source, contains('_phase12InternalOnlyRoutes'));
    expect(source, contains('MunasaknaEnvironment.internalToolsEnabled'));
    expect(source, contains('MunasaknaRoutes.betaReadiness'));
    expect(source, contains('MunasaknaRoutes.nusukBridgePreview'));
  });

  testWidgets('internal beta route redirects to home by default',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: munasaknaRouter)),
    );
    munasaknaRouter.go(MunasaknaRoutes.betaReadiness);
    await tester.pumpAndSettle();

    expect(
      munasaknaRouter.routeInformationProvider.value.uri.path,
      MunasaknaRoutes.home,
    );
  });

  test('pilgrim services surface does not advertise MVP/preview/mock tooling',
      () {
    final source = File(
      'lib/features/services/presentation/pages/services_page.dart',
    ).readAsStringSync();

    final publicCatalog =
        source.substring(source.indexOf('const _visualServices = ['));
    expect(publicCatalog, isNot(contains('MVP')));
    expect(publicCatalog, isNot(contains('معاينة')));
    expect(publicCatalog, isNot(contains('Mock')));
    expect(publicCatalog, isNot(contains('بيتا')));
  });
}
