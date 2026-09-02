# MANASIKUNA 1448 — Standalone & Pilgrim Data Foundation V1

TASK=MANASIKUNA_1448_STANDALONE_AND_PILGRIM_DATA_FOUNDATION_V1
BASE_SHA=3839b36338c1a4cc8e9a7515d72aae9c9a7de855
BASE_VERSION=2.9.5+37
TARGET_VERSION=2.9.6+38
PR_NUMBER=4
PR_REVIEW_HARDENING=APPLIED_PENDING_LOCAL_GATES_AND_REMOTE_READBACK

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
   - Connected modes require a non-null, time-valid activation credential.
   - Campaign provider absence, empty results, non-approved profiles, context mismatch, and provider exceptions fail closed to standalone.
   - Nusuk is used only when an injected provider reports official availability and returns an approved profile plus a non-null, context-matching operational pack.
   - Missing/partial/mismatched/erroring Nusuk data falls back to campaign and then standalone when needed.
   - Fallback reason metadata is absent on a successful direct path and preserved on actual fallback paths.
   - Nested fallback trails are represented as `prior_reason>current_reason`.
7. Campaign pack context validation:
   - campaign reference must match the pilgrim seed when the seed provides one;
   - group reference must not conflict when both seed and pack provide one;
   - activation `packId` must match the resolved pack when activation provides one.
8. Blank activation tokens are rejected by runtime constructor validation in release as well as debug.
9. Product package description identifies Manasikuna as an independent companion rather than implying it operates under Nusuk.

## Explicit non-goals

- No real Nusuk API.
- No scraping, reverse engineering, or simulated Nusuk login.
- No real pilgrim database.
- No Supabase personal-data mutation.
- No production deployment.
- No store release.
- No baseline promotion.
- No merge authorization.

## Required gates before repair commit/push

- PR #4 remains open with exact base/head before repair.
- Exact local branch/head/worktree gate.
- Remote task head equals the reviewed PR head before mutation.
- Remote `main` remains unchanged.
- `pubspec.lock` unchanged.
- `dart format` on repaired Dart files.
- Early `git diff --check` passes before expensive gates.
- Focused foundation regression tests pass.
- Full Flutter tests pass.
- Flutter Web release build passes.
- Staged `git diff --check` passes.
- Repair commit contains only the intended five repaired files.
- Remote task readback equals the new local repair commit.
- PR #4 head updates to the repair commit.
- Remote `main` remains unchanged after push.
- Independent post-push PR review is required before any merge decision.
