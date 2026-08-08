# manasikuna v1.6.1 — Home Overflow + Test Stabilization Fix

## Scope
This patch is a focused correction over v1.6.0 for the reported home-page overflow and the failing widget test.

## Key fixes
- Rebuilt the home page as a purely vertical mobile-first layout.
- Removed all nested scrollable widgets from the home page:
  - no horizontal `SingleChildScrollView` in the hero header.
  - no horizontal `ListView` for quick actions.
  - no grid/wrap with fixed-height service cards.
- Replaced the service grid with full-width mobile service tiles to prevent RenderFlex overflow on small screens and Arabic text scaling.
- Replaced quick actions with a non-scrollable `Wrap` of compact mobile action cards.
- Moved the readiness action button below the title row to avoid horizontal overflow.
- Kept the manasikuna visual identity applied through:
  - sacred hero header.
  - Kaaba mark.
  - green/gold visual accents.
  - identity background.
  - themed service tiles.
- Simplified `widget_test.dart` so it validates rendered core mobile services without depending on scroll/hit-test behavior.

## Version
`1.6.1+10`

## Files changed
- `munasakna_mobile/lib/features/home/presentation/pages/munasakna_home_page.dart`
- `munasakna_mobile/test/widget_test.dart`
- `munasakna_mobile/pubspec.yaml`

## Required local commands
```bash
flutter clean
flutter pub get
flutter analyze
flutter test
flutter run
```

## Notes
This patch intentionally avoids nested viewport patterns on the home page because the reported runtime stack pointed to Flutter Web/Chrome pointer hit testing through `RenderViewport.hitTestChildren`, and the user also reported home overflow. The new home page keeps only one vertical `ListView` at the root.
