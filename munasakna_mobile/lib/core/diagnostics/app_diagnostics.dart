import 'dart:collection';

enum AppDiagnosticCode {
  flutterFrameworkError,
  platformUncaughtError,
  zoneUncaughtError,
}

enum AppDiagnosticSource {
  flutterFramework,
  platformDispatcher,
  guardedZone,
}

typedef AppDiagnosticClock = DateTime Function();

class AppDiagnosticEvent {
  const AppDiagnosticEvent({
    required this.sequence,
    required this.code,
    required this.source,
    required this.occurredAtUtc,
  });

  final int sequence;
  final AppDiagnosticCode code;
  final AppDiagnosticSource source;
  final DateTime occurredAtUtc;

  Map<String, Object> toSafeMap() => <String, Object>{
        'sequence': sequence,
        'code': code.name,
        'source': source.name,
        'occurredAtUtc': occurredAtUtc.toIso8601String(),
      };
}

/// Privacy-safe, memory-only diagnostics for Wave D operability.
///
/// Deliberately excluded:
/// - exception messages;
/// - raw stack traces;
/// - user-entered text;
/// - location, voice or profile payloads;
/// - activation tokens or identifiers;
/// - network telemetry and persistence.
class AppDiagnostics {
  AppDiagnostics({
    this.capacity = defaultCapacity,
    AppDiagnosticClock? clock,
  }) : _clock = clock ?? _utcNow {
    if (capacity <= 0 || capacity > maximumCapacity) {
      throw ArgumentError.value(
        capacity,
        'capacity',
        'must be between 1 and $maximumCapacity',
      );
    }
  }

  static const int defaultCapacity = 64;
  static const int maximumCapacity = 256;

  static const bool persistsDiagnostics = false;
  static const bool externalTelemetryEnabled = false;

  static final AppDiagnostics instance = AppDiagnostics();

  final int capacity;
  final AppDiagnosticClock _clock;
  final ListQueue<AppDiagnosticEvent> _events =
      ListQueue<AppDiagnosticEvent>();

  int _nextSequence = 1;

  void record({
    required AppDiagnosticCode code,
    required AppDiagnosticSource source,
  }) {
    if (_events.length == capacity) {
      _events.removeFirst();
    }

    _events.addLast(
      AppDiagnosticEvent(
        sequence: _nextSequence++,
        code: code,
        source: source,
        occurredAtUtc: _clock().toUtc(),
      ),
    );
  }

  List<AppDiagnosticEvent> snapshot() =>
      List<AppDiagnosticEvent>.unmodifiable(_events);

  void clear() {
    _events.clear();
  }

  static DateTime _utcNow() => DateTime.now().toUtc();
}
