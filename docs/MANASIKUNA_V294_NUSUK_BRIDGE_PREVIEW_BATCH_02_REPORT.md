# MANASIKUNA v294 — Nusuk Bridge Preview Batch 02

## Scope
This batch extends the v292 preview registry with typed, local-only integration contracts.

Implemented:
- `NusukPilgrimProfileDto`
- `NusukJourneyOverviewDto`
- `NusukContactsDto`
- `NusukFeedbackSubmissionDto`
- Manual `fromJson` / `toJson`
- `NusukLocalPreviewDataSource`
- `NusukRemoteDataSource`
- `NusukBridgeRepository`
- `NusukBridgeFeatureMode`
- Guarded runtime states: loading, data, empty, error, offline, needsLogin, needsConsent
- Local contract tests and endpoint-regression checks

## Safety boundary
This batch DOES NOT enable:
- real Nusuk API calls
- login/authentication
- Supabase
- real server writes
- production deployment
- store release
- any claim of official Nusuk integration

The remote and repository types are contracts only. No HTTP client, credentials, tokens, Supabase client, RPC, REST call, or production write path is implemented.

## Version
`2.9.4+36`

## Acceptance
Before commit/push:
1. `git diff --check`
2. focused v294 contract test passes
3. full `flutter test` passes
4. `pubspec.lock` remains unchanged because dependencies were not changed
5. diff review confirms only intended v294 files/version/docs changed
