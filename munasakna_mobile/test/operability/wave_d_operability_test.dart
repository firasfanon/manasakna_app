import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/core/diagnostics/app_diagnostics.dart';

void main() {
  test('diagnostics are bounded memory-only and expose safe metadata only', () {
    final fixedNow = DateTime.utc(2026, 9, 8, 1, 30);
    final diagnostics = AppDiagnostics(
      capacity: 3,
      clock: () => fixedNow,
    );

    for (var i = 0; i < 5; i++) {
      diagnostics.record(
        code: AppDiagnosticCode.flutterFrameworkError,
        source: AppDiagnosticSource.flutterFramework,
      );
    }

    final events = diagnostics.snapshot();

    expect(events, hasLength(3));
    expect(events.first.sequence, 3);
    expect(events.last.sequence, 5);
    expect(events.every((event) => event.occurredAtUtc == fixedNow), isTrue);
    expect(AppDiagnostics.persistsDiagnostics, isFalse);
    expect(AppDiagnostics.externalTelemetryEnabled, isFalse);

    final safe = events.last.toSafeMap();
    expect(
      safe.keys.toSet(),
      <String>{'sequence', 'code', 'source', 'occurredAtUtc'},
    );
    expect(safe.toString(), isNot(contains('token')));
    expect(safe.toString(), isNot(contains('stack')));
    expect(safe.toString(), isNot(contains('message')));
  });

  test('global error capture is wired without print or external telemetry', () {
    final mainSource = File('lib/main.dart').readAsStringSync();
    final diagnosticsSource =
        File('lib/core/diagnostics/app_diagnostics.dart').readAsStringSync();

    expect(mainSource, contains('FlutterError.onError'));
    expect(mainSource, contains('PlatformDispatcher.instance.onError'));
    expect(mainSource, contains('runZonedGuarded'));
    expect(mainSource, contains('Zone.root.handleUncaughtError'));
    expect(mainSource, contains('return false'));

    expect(diagnosticsSource, isNot(contains('debugPrint(')));
    expect(diagnosticsSource, isNot(contains('print(')));
    expect(diagnosticsSource, isNot(contains('http://')));
    expect(diagnosticsSource, isNot(contains('https://')));
  });

  test('Android wrapper and migrator configuration are source-controlled', () {
    final androidIgnore = File('android/.gitignore').readAsStringSync();
    final wrapper =
        File('android/gradle/wrapper/gradle-wrapper.properties')
            .readAsStringSync();
    final buildGradle = File('android/app/build.gradle').readAsStringSync();
    final gradleProperties =
        File('android/gradle.properties').readAsStringSync();

    expect(androidIgnore, isNot(contains('gradle-wrapper.jar')));
    expect(androidIgnore, isNot(contains('/gradlew\n')));
    expect(androidIgnore, isNot(contains('/gradlew.bat')));
    expect(androidIgnore, contains('key.properties'));
    expect(androidIgnore, contains('**/*.keystore'));
    expect(androidIgnore, contains('**/*.jks'));

    expect(File('android/gradlew').existsSync(), isTrue);
    expect(File('android/gradlew.bat').existsSync(), isTrue);
    expect(
      File('android/gradle/wrapper/gradle-wrapper.jar').existsSync(),
      isTrue,
    );

    expect(
      wrapper,
      contains('gradle-8.10.2-all.zip'),
    );
    expect(
      wrapper,
      contains(
        'distributionSha256Sum='
        '2ab88d6de2c23e6adae7363ae6e29cbdd2a709e992929b48b6530fd0c7133bd6',
      ),
    );

    expect(
      buildGradle,
      contains('minSdkVersion = flutter.minSdkVersion'),
    );
    expect(
      gradleProperties,
      contains('android.builtInKotlin=false'),
    );
    expect(
      gradleProperties,
      contains('android.newDsl=false'),
    );
  });
}
