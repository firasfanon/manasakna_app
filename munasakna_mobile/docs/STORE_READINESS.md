# Manasikuna Store Readiness

## Scope

This package remains an independent local-first Hajj and Umrah companion:

- No login.
- No external pilgrim database.
- No real pilgrim data.
- No Supabase/Firebase/Auth/Ads/Analytics dependency in the current app runtime.
- Optional location permission when the user opens “موقعي الحالي”.
- Optional microphone permission when the user explicitly uses voice input.
- Settings and the synthetic 1448 journey snapshot are stored locally.
- The raw activation token is not persisted in the journey snapshot.
- Nusuk is an optional future provider, not a current launch dependency.

## Voice-service disclosure

Speech recognition may be provided by the operating system or browser. Depending on platform configuration, the platform provider may process speech input under its own policies. Manasikuna does not operate a speech-audio ingestion backend in this release.

Text-to-speech uses the voice service available on the operating system or browser.

Store privacy/Data Safety answers must therefore be revalidated for each target platform and cannot be copied mechanically from an earlier “no data” answer.

## Android

Package ID:

```text
ps.manasikuna.app
```

Current baseline manifest requests:

- `RECORD_AUDIO`
- `ACCESS_FINE_LOCATION`
- `ACCESS_COARSE_LOCATION`
- `usesCleartextTraffic=false`

Wave A proved that a debug APK can be produced in an isolated snapshot, but Android reproducible release/toolchain closure remains a later release/operability gate. Debug-build success is not store approval.

## iOS

Bundle ID:

```text
ps.manasikuna.app
```

The current `PrivacyInfo.xcprivacy` declares no app tracking and no app-collected data types. This declaration remains valid only while the current standalone/local data boundary remains true and must be revalidated before any real-data or third-party service integration.

iOS runtime/store acceptance still requires macOS/Xcode/device evidence.

## Web

The Web build is supported as the standalone Flutter Web application. Flutter owns viewport configuration; the app shell must not override Flutter’s generated viewport policy in a way that blocks zoom/accessibility.

## Privacy console review checklist

Before any store submission, verify the actual target-platform behavior for:

- App-operated data collection.
- Data sharing.
- Tracking.
- Account creation/deletion.
- Optional location permission.
- Optional microphone permission.
- OS/browser speech-recognition processing.
- Any SDK added after this baseline.

## Deferred integrations

Any future backend bridge, official pilgrim data, payment flow, document upload, real Campaign Pack ingestion, or official verification requires a separate authorization and privacy/security/store-disclosure review.

`PRODUCTION=NO` and `STORE_RELEASE=NO` remain in force until a separate release decision.
