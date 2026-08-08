# manasikuna v1.2 — Analyze/Test Fix Report

## Scope
This patch fixes the compile blocker reported by `flutter analyze` and `flutter test` after v1.1.

## Fixed

### 1. Riverpod AsyncNotifier method collision
File:
- `lib/features/settings/presentation/providers/settings_provider.dart`

Problem:
- `AppSettingsController.update(manasikunaAppSettings settings)` collided with `AsyncNotifierBase.update(...)` from Riverpod 2.6.1.

Change:
- Renamed the app-specific method to `persistSettings(...)`.
- Updated all controller setters to call `persistSettings(...)`.

### 2. Deprecated DropdownButtonFormField value usage
Files:
- `lib/features/settings/presentation/pages/settings_page.dart`
- `lib/features/complaints/presentation/pages/complaints_page.dart`

Change:
- Replaced deprecated `value:` with `initialValue:`.

### 3. Deprecated geolocator desiredAccuracy usage
File:
- `lib/features/location/presentation/pages/current_location_page.dart`

Change:
- Replaced `desiredAccuracy:` with `locationSettings: const LocationSettings(...)`.

### 4. Minor const cleanup
Files:
- `lib/features/digital_card/presentation/pages/digital_card_page.dart`
- `lib/features/health/presentation/pages/health_page.dart`
- `lib/features/home/presentation/pages/munasakna_home_page.dart`
- `lib/features/rituals/presentation/pages/rituals_page.dart`

Change:
- Added const constructors where safe.

## Local validation required
Run on the developer machine:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
```

The previous fatal blocker should be resolved. Any remaining findings, if present, should be informational style warnings rather than compile/test blockers.
