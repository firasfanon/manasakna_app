# manasikuna Store Readiness

## Scope

manasikuna is prepared in this package as an independent local-first mobile app:

- No login.
- No external database.
- No Supabase/Firebase/Auth/Ads/Analytics dependency.
- Optional location permission only when the user taps "موقعي الحالي".
- Local references are generated on-device for complaints, surveys, and profile update requests.
- Settings are saved locally using SharedPreferences.

## Android

Package ID:

```text
ps.manasikuna.app
```

Release settings:

- compileSdk: 35
- targetSdk: 35
- minSdk: 23
- release shrink/minify enabled
- release signing via `android/key.properties`

Before publishing:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
./tools/create_android_upload_keystore.sh
flutter build appbundle --release
```

## iOS

Bundle ID:

```text
ps.manasikuna.app
```

Included:

- `ios/Runner/Info.plist` with location usage text.
- `ios/Runner/PrivacyInfo.xcprivacy` declaring no tracking and no collected data.
- iOS project Bundle ID updated to `ps.manasikuna.app`.

Before publishing:

```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter build ipa --release
```

Use current Xcode / iOS SDK required by App Store at the time of upload.

## Privacy console answers

Suggested classification, if no extra SDKs are added:

- Data collected: No.
- Data shared: No.
- Tracking: No.
- Account creation: No.
- Account deletion: Not applicable.
- Permissions: Location when in use, optional, used locally.

## Deferred integrations

Any future backend bridge, payment flow, document upload, or official verification must be introduced as a separate reviewed batch with privacy and store disclosure updates.
