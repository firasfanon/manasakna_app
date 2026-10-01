import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('web bootstrap is accessible and clears static loading state', () {
    final index = File('web/index.html').readAsStringSync();

    expect(index, contains('role="status"'));
    expect(index, contains('aria-live="polite"'));
    expect(index, contains('flutter-first-frame'));
    expect(index, contains("document.getElementById('app-loading')?.remove()"));
    expect(index, contains('favicon.png'));
    expect(index, contains('icons/Icon-192.png'));

    final bootstrap = File('web/flutter_bootstrap.js').readAsStringSync();
    expect(bootstrap, contains("fontFallbackBaseUrl: 'fallback_fonts/'"));
    expect(
      File('web/fallback_fonts/roboto/v32/KFOmCnqEu92Fr1Me4GZLCzYlKw.woff2')
          .existsSync(),
      isTrue,
    );
    expect(File('web/fallback_fonts/roboto/OFL.txt').existsSync(), isTrue);
  });

  test('web app has complete local icon manifest', () {
    final manifest = jsonDecode(File('web/manifest.json').readAsStringSync())
        as Map<String, dynamic>;
    final icons =
        (manifest['icons'] as List<dynamic>).cast<Map<String, dynamic>>();

    expect(icons, hasLength(4));
    expect(File('web/favicon.png').existsSync(), isTrue);

    expect(File('web/icons/Icon-192.png').existsSync(), isTrue);
    expect(File('web/icons/Icon-512.png').existsSync(), isTrue);
    expect(File('web/icons/Icon-maskable-192.png').existsSync(), isTrue);
    expect(File('web/icons/Icon-maskable-512.png').existsSync(), isTrue);
    expect(manifest['dir'], 'rtl');
    expect(manifest['lang'], 'ar');
  });

  test('Arabic font is bundled locally for degraded web operation', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('family: NotoSansArabic'));
    expect(pubspec, contains('assets/fonts/NotoSansArabic-Variable.ttf'));
    expect(
        File('assets/fonts/NotoSansArabic-Variable.ttf').existsSync(), isTrue);
    expect(File('assets/fonts/OFL.txt').existsSync(), isTrue);
  });

  test('Phase 10 provider authority remains closed during Phase 11', () {
    final manifest = jsonDecode(
      File(
        '../docs/MANASAKNA_PHASE_10_PROVIDER_INTEGRATION_CONTRACT_V1.json',
      ).readAsStringSync(),
    ) as Map<String, dynamic>;

    expect(manifest['real_provider_activation_authorized'], isFalse);
    expect(manifest['shared_database_mutation'], isFalse);
    expect(manifest['direct_cross_plane_db_access'], isFalse);
    expect(manifest['production'], isFalse);
    expect(manifest['real_data'], isFalse);
  });

  test(
    'JavaScript remains the supported web target while WASM is non-blocking',
    () {
      final contract = File(
        'docs/WAVE_D_OPERABILITY_RELEASE_ROLLBACK_V1.md',
      ).readAsStringSync();
      final pubspec = File('pubspec.yaml').readAsStringSync();

      expect(
        contract,
        contains('supported Wave D web release target remains JavaScript'),
      );
      expect(contract, contains('WASM'));
      expect(contract, contains('non-blocking toolchain/upstream limitation'));
      expect(pubspec, contains('flutter_tts: ^4.2.5'));
    },
  );
}
