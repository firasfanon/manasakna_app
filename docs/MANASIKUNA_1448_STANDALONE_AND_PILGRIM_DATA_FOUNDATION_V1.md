# MANASIKUNA 1448 — Standalone & Pilgrim Data Foundation V1

TASK=MANASIKUNA_1448_STANDALONE_AND_PILGRIM_DATA_FOUNDATION_V1
BASE_SHA=3839b36338c1a4cc8e9a7515d72aae9c9a7de855
BASE_VERSION=2.9.5+37
TARGET_VERSION=2.9.6+38

## Strategic boundary

- Manasikuna launches as an independent Hajj companion.
- Nusuk is an optional future provider, not a launch dependency.
- Default runtime mode is `STANDALONE`.
- Supported target modes are `STANDALONE`, `CAMPAIGN_CONNECTED`, and `NUSUK_CONNECTED`.
- Manasikuna does not run, decide, or reinterpret the Hajj lottery.
- The primary pilgrim identity seed is the read-only set of officially approved pilgrims after registration and lottery, received only from an authorized source.
- Campaign Operational Pack is the pre-Nusuk source for group, supervisor, hotel, transport, camps, meeting points, schedule, and emergency contacts.
- Activation uses an opaque token / tokenized QR. Personal data must not be embedded in the token.
- No real pilgrim data is used in this foundation batch; tests use synthetic fixtures only.

## Foundation implemented

1. `ManasikunaIntegrationMode` independent of the older Nusuk preview feature modes.
2. Minimal `OfficialPilgrimSeed` contract with explicit source authority, source revision, and read-only acceptance status.
3. `CampaignOperationalPack` contract for campaign-managed operational data.
4. `ActivationCredential` as opaque, expiring activation material.
5. Provider interfaces for pilgrim profile, campaign operations, official-service handoff, and future Nusuk compatibility.
6. Runtime resolver with launch-safe fallback:
   - Standalone never calls Nusuk.
   - Campaign mode falls back to standalone if activation/provider/data is unavailable.
   - Nusuk mode is usable only when an injected provider reports official availability; otherwise it falls back to campaign then standalone.
   - Expired activation fails closed to standalone.
   - Non-approved official seed cannot activate campaign context.

## Explicit non-goals

- No real Nusuk API.
- No scraping, reverse engineering, or simulated Nusuk login.
- No real pilgrim database.
- No Supabase personal-data mutation.
- No production deployment.
- No store release.
- No baseline promotion.
- No merge authorization.

## Required gates before commit/push

- Exact base/head/worktree gate.
- Exact six-file changeset.
- `pubspec.lock` unchanged.
- `dart format` on new Dart files.
- Focused foundation tests pass.
- Full Flutter tests pass.
- Flutter Web release build passes.
- `git diff --check` passes.
- Commit parent equals the v295 integrated head.
- Remote task readback equals local task commit.
- Remote `main` remains unchanged.
