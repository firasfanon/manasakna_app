# manasikuna v1.6.0 — Visual Identity Applied + Mobile Viewport Fix

## Scope
This delivery applies the manasikuna visual identity inside the running application, not only in isolated theme files. It also removes the brittle home-page Sliver viewport that was linked to the Web/Chrome pointer hit-test exception.

## User-reported issue
- Visual identity did not appear clearly inside the application.
- Pointer exception occurred while handling pointer data packets in Flutter Web/Chrome:
  - `TypeErrorImpl: Unexpected null value`
  - stack included `package:flutter/src/rendering/viewport.dart ... hitTestChildren`.

## Main fixes
1. Replaced the home screen `CustomScrollView + SliverGrid` with a safer mobile `ListView + Wrap` services grid.
2. Updated `ManasikunaBackground` to use `StackFit.expand` and `Positioned.fill(child: child)` so decorative layers never interfere with layout/hit testing.
3. Added visible global identity to all scaffold pages:
   - gradient branded AppBar,
   - Kaaba mark,
   - gold separator,
   - page banner with service label.
4. Strengthened the visual identity on:
   - Home hero,
   - Bottom navigation,
   - Service cards,
   - Info section cards,
   - Global page background.
5. Kept the app independent and local-first:
   - no login,
   - no database,
   - no external data transmission,
   - package id remains `ps.manasikuna.app`.

## Files changed
- `lib/core/widgets/manasikuna_visual_identity.dart`
- `lib/core/widgets/munasakna_app_scaffold.dart`
- `lib/core/widgets/munasakna_bottom_nav.dart`
- `lib/core/widgets/service_card.dart`
- `lib/core/widgets/info_section_card.dart`
- `lib/features/home/presentation/pages/munasakna_home_page.dart`
- `pubspec.yaml`

## Version
- `1.6.0+9`

## Required local checks
Run locally:

```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter run
```

If testing the mobile app, prefer Android emulator/device or iOS simulator/device. Chrome can still be useful for quick UI preview, but this is a mobile application and the target acceptance path is Android/iOS.
