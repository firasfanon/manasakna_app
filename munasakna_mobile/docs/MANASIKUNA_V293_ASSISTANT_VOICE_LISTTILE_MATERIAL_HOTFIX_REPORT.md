# MANASIKUNA V293 — ASSISTANT VOICE LISTTILE MATERIAL HOTFIX REPORT

## Status

- Version: `2.9.3+35`
- Baseline parent: `v292 — Nusuk Bridge Preview Batch 01`
- Change type: targeted test/runtime hygiene hotfix.
- Login/Auth: not enabled.
- Real Nusuk connection: not enabled.
- Real user data: not used.

## Issue

Local `flutter test` failed on the assistant voice page because Flutter asserted that a `ListTile`/`SwitchListTile` was placed under a decorated background without its own `Material` ancestor. This can hide ink/splash/background effects and is treated as a framework exception during tests.

## Fix

Wrapped the auto-send `SwitchListTile.adaptive` in `Material(color: Colors.transparent)` inside:

```text
munasakna_mobile/lib/features/hajj_assistant/presentation/pages/simple_hajj_assistant_page.dart
```

## Acceptance required locally

```powershell
cd C:\Users\DELL\StudioProjects\manasakna_app\munasakna_mobile
flutter clean
flutter pub get
flutter test
```

Expected result:

```text
All tests passed
```

## Governance note

This hotfix does not approve production, store release, database mutation, official Nusuk affiliation, or real API integration. It only closes the local widget-test blocker discovered after v292.
