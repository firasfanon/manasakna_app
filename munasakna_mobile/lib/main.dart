import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/munasakna_app.dart';
import 'core/diagnostics/app_diagnostics.dart';

void main() {
  final diagnostics = AppDiagnostics.instance;

  runZonedGuarded<void>(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      final previousFlutterErrorHandler = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        diagnostics.record(
          code: AppDiagnosticCode.flutterFrameworkError,
          source: AppDiagnosticSource.flutterFramework,
        );

        if (previousFlutterErrorHandler != null) {
          previousFlutterErrorHandler(details);
        } else {
          FlutterError.presentError(details);
        }
      };

      final previousPlatformErrorHandler = PlatformDispatcher.instance.onError;
      PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
        diagnostics.record(
          code: AppDiagnosticCode.platformUncaughtError,
          source: AppDiagnosticSource.platformDispatcher,
        );

        if (previousPlatformErrorHandler != null) {
          return previousPlatformErrorHandler(error, stack);
        }

        // False preserves the platform's normal uncaught-error semantics.
        return false;
      };

      runApp(const ProviderScope(child: MunasaknaApp()));
    },
    (Object error, StackTrace stack) {
      diagnostics.record(
        code: AppDiagnosticCode.zoneUncaughtError,
        source: AppDiagnosticSource.guardedZone,
      );

      // Preserve normal uncaught-error behavior after recording only safe
      // metadata. Wave D diagnostics must never swallow failures.
      Zone.root.handleUncaughtError(error, stack);
    },
  );
}
