import 'package:flutter_test/flutter_test.dart';
import 'package:munasakna_mobile/core/diagnostics/app_diagnostics.dart';

void main() {
  test('diagnostic memory remains deterministically bounded under load', () {
    final diagnostics = AppDiagnostics(
      capacity: AppDiagnostics.defaultCapacity,
      clock: () => DateTime.utc(2026, 9, 8),
    );

    for (var i = 0; i < 10000; i++) {
      diagnostics.record(
        code: AppDiagnosticCode.platformUncaughtError,
        source: AppDiagnosticSource.platformDispatcher,
      );
    }

    final snapshot = diagnostics.snapshot();

    expect(snapshot, hasLength(AppDiagnostics.defaultCapacity));
    expect(snapshot.first.sequence, 9937);
    expect(snapshot.last.sequence, 10000);
  });

  test('performance contract avoids flaky wall-clock pass/fail thresholds', () {
    expect(AppDiagnostics.defaultCapacity, 64);
    expect(AppDiagnostics.maximumCapacity, 256);
    expect(AppDiagnostics.defaultCapacity < AppDiagnostics.maximumCapacity,
        isTrue);
  });
}
