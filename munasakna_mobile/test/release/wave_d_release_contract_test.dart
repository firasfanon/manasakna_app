import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Wave D release runbook preserves governance boundaries', () {
    final runbook =
        File('docs/WAVE_D_OPERABILITY_RELEASE_ROLLBACK_V1.md')
            .readAsStringSync();

    expect(runbook, contains('PRODUCTION=NO'));
    expect(runbook, contains('STORE_RELEASE=NO'));
    expect(runbook, contains('REAL_DATA=NO'));
    expect(runbook, contains('REAL_NUSUK=NO'));
    expect(runbook, contains('rollback'));
    expect(runbook, contains('SHA-256'));
    expect(runbook, contains('ANALYZER_ISSUE_CEILING=98'));
    expect(
      runbook,
      contains('VALIDATION_SIGNING=DEBUG_ONLY_WHEN_EXPLICITLY_ENABLED'),
    );
  });

  test('CI is validation-only and contains no deployment or store step', () {
    final workflow =
        File('../.github/workflows/manasakna-wave-d-ci.yml')
            .readAsStringSync();

    expect(workflow, contains('flutter test'));
    expect(workflow, contains('flutter build web --release'));
    expect(workflow, contains('flutter build apk --release'));
    expect(workflow, contains('flutter build appbundle --release'));
    expect(workflow, contains('flutter build ios --release --no-codesign'));
    expect(workflow, contains('permissions:\n  contents: read'));

    expect(workflow.toLowerCase(), isNot(contains('deploy')));
    expect(workflow.toLowerCase(), isNot(contains('play store')));
    expect(workflow.toLowerCase(), isNot(contains('app store')));
    expect(workflow, isNot(contains('secrets.')));

    final buildGradle =
        File('android/app/build.gradle').readAsStringSync();

    expect(
      workflow,
      contains('MANASAKNA_ALLOW_LOCAL_VALIDATION_SIGNING'),
    );
    expect(
      workflow,
      contains('DEBUG_VALIDATION_ONLY_IF_RELEASE_KEY_ABSENT'),
    );
    expect(
      buildGradle,
      contains('compileSdk = flutter.compileSdkVersion'),
    );
    expect(
      buildGradle,
      contains('MANASAKNA_ALLOW_LOCAL_VALIDATION_SIGNING'),
    );
    expect(
      buildGradle,
      contains('else if (allowLocalValidationSigning)'),
    );
    expect(
      buildGradle,
      contains('signingConfig = signingConfigs.debug'),
    );
  });
}
