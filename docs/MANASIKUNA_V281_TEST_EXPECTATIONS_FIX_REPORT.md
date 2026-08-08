# MANASIKUNA v2.8.1 — Test Expectations Fix

## Summary
This maintenance batch fixes two widget-test expectation issues reported after v2.8.0 without changing product behavior or page structure.

## Fixes
- Updated the services-page widget test to scroll to service cards that are lower in the visual service list before asserting them.
- Updated the assistant-page widget test to accept multiple visible occurrences of the title "المساعد الصوتي الذكي" because the title may appear both in page chrome and content/service context.
- Bumped app version to `2.8.1+26`.

## Scope
- No UI redesign.
- No route changes.
- No dependency changes.
- No database or Nusuk API changes.

## Files changed
- `munasakna_mobile/test/widget_test.dart`
- `munasakna_mobile/pubspec.yaml`
- `docs/MANASIKUNA_V281_TEST_EXPECTATIONS_FIX_REPORT.md`
- `docs/MANASIKUNA_COMPREHENSIVE_SYSTEM_GUIDE.md`

