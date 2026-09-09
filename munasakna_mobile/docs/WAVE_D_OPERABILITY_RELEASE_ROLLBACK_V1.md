# MANASAKNA 1448 — Wave D Operability, Release and Rollback Contract V1

Status: source-development contract. It does **not** approve production or store release.

## Governing boundaries

```text
PRODUCTION=NO
STORE_RELEASE=NO
REAL_ENDPOINT_CONNECTION=NO
REAL_DATA=NO
REAL_PILGRIM_DATA=NO
SUPABASE_PERSONAL_DATA_MUTATION=NO
REAL_NUSUK=NO
WAVE_E=NO
```

Wave D closes operability evidence only. Merge, sovereign baseline promotion,
production, store submission and real-data activation remain separate gates.

## Toolchain identity

Expected source baseline:

```text
BASELINE=MANASAKNA_APP_BASELINE_0F6BFD4A_20260908
BASE_SHA=0f6bfd4ab91e57fa3f2e5b89a86a903a50c2059d
BASE_TREE=9f76ef7e84ef5e62927bf71ce5d48c476532e023
FLUTTER=3.44.1
DART=3.12.1
ANDROID_MIN_SDK=24
GRADLE=8.10.2
ANALYZER_ISSUE_CEILING=98
```

Android uses the complete Gradle Wrapper unit in source control. The Wrapper JAR
must match the official Gradle 8.10.2 SHA-256:

```text
2db75c40782f5e8ba1fc278a5574bab070adccb2d21ca5a6e5ed840888448046
```

The `gradle-8.10.2-all.zip` distribution is pinned by
`distributionSha256Sum` to:

```text
2ab88d6de2c23e6adae7363ae6e29cbdd2a709e992929b48b6530fd0c7133bd6
```

## Android validation signing

```text
VALIDATION_SIGNING=DEBUG_ONLY_WHEN_EXPLICITLY_ENABLED
PRODUCTION_SIGNING=SEPARATE_AUTHORITY_GATE
STORE_READY_SIGNING=NO
```

If key.properties exists, Android release builds use the configured release key.
If it does not exist, Wave D local/CI validation may use Android debug signing
only when MANASAKNA_ALLOW_LOCAL_VALIDATION_SIGNING=1 is explicitly set.
This proves release compilation/package operability only. It does not produce
a store-ready or production-approved artifact.

The app uses flutter.compileSdkVersion for compile-time plugin compatibility.
targetSdk remains 35 in this Wave D repair; changing target behavior requires
separate evidence and is not necessary to close the current packaging failure.

## Operability

The app records only bounded, memory-only diagnostic metadata for uncaught
Flutter framework, platform-dispatcher and guarded-zone errors.

Diagnostics deliberately do **not** retain exception messages, raw stack traces,
user input, profile payloads, activation tokens, location, voice data or other
personal data. No external telemetry endpoint is enabled in Wave D.

Provider timeout and degraded/fallback semantics from Wave C remain unchanged;
Wave D does not perform a broad resilience rewrite.

## Performance baseline

Wave D performance evidence has two layers:

1. deterministic source contracts that keep diagnostic memory bounded;
2. measured build/test durations and artifact sizes recorded as evidence.

Wall-clock timings are evidence, not flaky pass/fail thresholds. A later
regression budget may be adopted only from repeated comparable measurements.

Discovery baseline observed before source development:

```text
FULL_FLUTTER_TEST=PASS_69
ANALYZER_ISSUES=98
WEB_JS_RELEASE=PASS
WEB_BUILD_ELAPSED_MS≈54150
WEB_BUILD_BYTES≈44376058
```

## Validation sequence

A Wave D candidate must pass, in order:

1. exact repository, baseline, version and toolchain identity;
2. Gradle Wrapper JAR and distribution checksum verification;
3. full Flutter test suite;
4. analyzer with zero errors and total issues <= 98;
5. Web JS release build;
6. Android APK release build;
7. Android App Bundle release build;
8. post-build source-hash comparison proving no Flutter auto-migration drift;
9. artifact SHA-256 and byte-size receipt;
10. clean staged area and exact Wave D changeset;
11. remote `main` unchanged from the authorized base.

CI additionally performs macOS `flutter build ios --release --no-codesign`.
That is compile evidence only; signed iOS/store evidence remains a later gate.

## Release evidence schema

For each release-candidate validation capture:

```text
SOURCE_SHA
SOURCE_TREE
VERSION
FLUTTER_VERSION
DART_VERSION
GRADLE_VERSION
ANDROID_MIN_SDK
TEST_RESULT
ANALYZER_ISSUE_COUNT
WEB_BUILD_RESULT
APK_SHA256
APK_BYTES
AAB_SHA256
AAB_BYTES
IOS_NO_CODESIGN_RESULT
CHANGED_FILES
REMOTE_MAIN_READBACK
```

## Rollback

Rollback is source-identity driven, never a production action by implication.

Before a later production decision, record the exact previous accepted
sovereign baseline. If a candidate fails validation or is rejected:

1. stop promotion;
2. preserve failure evidence;
3. restore or recreate the candidate from the previous accepted source SHA;
4. verify source tree, version and local-state compatibility;
5. rerun the required validation gates;
6. never mutate real data or production merely to make rollback succeed.

Current rollback anchor:

```text
SOVEREIGN_BASELINE=MANASAKNA_APP_BASELINE_0F6BFD4A_20260908
SOURCE_SHA=0f6bfd4ab91e57fa3f2e5b89a86a903a50c2059d
SOURCE_TREE=9f76ef7e84ef5e62927bf71ce5d48c476532e023
VERSION=2.10.2+41
```

## WebAssembly decision

The supported Wave D web release target remains JavaScript. `flutter_tts 4.2.5`
is already the selected dependency, while the measured Flutter 3.44.1 WASM path
still reports JS-interop incompatibility. WASM is therefore a documented,
non-blocking toolchain/upstream limitation and is revalidated only after a
Flutter/Dart or plugin change, or when WASM becomes an explicit release target.
