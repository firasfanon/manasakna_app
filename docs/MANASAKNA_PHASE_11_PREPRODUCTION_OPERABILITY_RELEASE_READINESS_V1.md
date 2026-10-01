# Manasakna Phase 11 — Preproduction Operability & Release Readiness

Status: ENGINEERING_EVIDENCE_COMPLETE_PENDING_SEPARATE_INTEGRATION_AND_BASELINE_DECISION

## Authorized exact base

- App head: `4123f6c5a6fc94801ddad99c57c43c2e58105e59`
- App tree: `18100652586cc23b672c0e227eff02da171dd2d4`
- Branch: `task/MANASAKNA-PHASE11-PREPROD-OPERABILITY-RELEASE-READINESS-V1`
- Execution device: `Futuer-IT`

## Governing boundaries

```text
DB_MUTATION=NO
REAL_PROVIDER=NO
REAL_DATA=NO
PRODUCTION=NO
STORE_RELEASE=NO
MAIN_MERGE_AUTHORITY=NO
BASELINE_PROMOTION_AUTHORITY=NO
```

Phase 10/G10 remain closed. Phase 11 does not alter the Hajj/Umrah authority model.
## Phase 11 changes

- Web bootstrap loading state is accessible and removed on first Flutter frame.
- Local favicon and PWA icon coverage added.
- Noto Sans Arabic is bundled locally under OFL.
- Flutter font fallback is redirected to a same-origin local `fallback_fonts/` tree.
- The exact Roboto fallback requested by Flutter is bundled locally under OFL.
- Phase 10 real-provider/data/DB/production closures remain regression-tested.
- Existing Wave D memory-only diagnostics, resilience and rollback contracts are retained.
- JavaScript remains the supported Web release target; WASM remains non-blocking while `flutter_tts` is incompatible with the current WASM path.

## Verification

- Phase 11 targeted tests: PASS (5)
- Full Flutter suite: PASS (157)
- Analyzer: 0 errors, 8 warnings, 90 infos, total 98
- Historical analyzer ceiling: 98
- Analyzer regression: NO
- Release Web build: PASS
- External font/CDN requests during blocked-DNS UAT:
  - `fonts.gstatic.com=0`
  - `www.gstatic.com=0`
  - `fonts.googleapis.com=0`
- Local fallback font request observed: YES
- Desktop visual UAT: PASS
- 390px visual UAT: PASS
- Restart/recovery HTTP readback: PASS / 200
## Android validation packaging

Validation-only signing was explicitly enabled with:
`MANASAKNA_ALLOW_LOCAL_VALIDATION_SIGNING=1`

`android/key.properties` was absent, so the validation build used debug signing only.
No Store or production signing authority was exercised.

- APK: PASS
  - bytes: 58,484,172
  - SHA-256: `b35db3fe82afea3b862bfd0ea24e7e8e2cfc90cfb8013038fb539ab213e3040d`
- AAB: PASS
  - bytes: 56,908,551
  - SHA-256: `f8875b93424b4c8eef4fe9beab5aaf832de2b942a71f134f384a79e44dced97d`
- Web main.dart.js:
  - bytes: 4,186,957
  - SHA-256: `86a8c9dcc841b3c8aa094cf20829c26923c1da0f7233bbd04e2e3972dd84c7aa`

Gradle wrapper identity remains pinned:
- wrapper JAR SHA-256: `2db75c40782f5e8ba1fc278a5574bab070adccb2d21ca5a6e5ed840888448046`
- Gradle 8.10.2 distribution SHA-256: `2ab88d6de2c23e6adae7363ae6e29cbdd2a709e992929b48b6530fd0c7133bd6`
## Non-blocking release-readiness debt

Current Flutter reports future-compatibility warnings for:
- Gradle 8.10.2 (future minimum 8.14.0);
- Android Gradle Plugin 8.7.3 (future minimum 8.11.1);
- Kotlin 2.1.0 (future minimum 2.2.20);
- plugin migration toward Built-in Kotlin.

These warnings do not block the current validated APK/AAB builds and are not upgraded automatically in this Phase 11 batch to avoid unbounded toolchain drift.

## Gate result

```text
G11-0=PASS
G11-1=PASS
G11-2=PASS
G11-3=PASS
G11-4=PASS
G11-5=PASS_WITH_NON_BLOCKING_FUTURE_TOOLCHAIN_DEBT
G11-6=PASS
G11-FINAL=ENGINEERING_EVIDENCE_COMPLETE
```

Next authority gate: separate integration and sovereign baseline decision.
