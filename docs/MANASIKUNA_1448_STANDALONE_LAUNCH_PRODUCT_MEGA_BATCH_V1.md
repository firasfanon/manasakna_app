# MANASIKUNA 1448 — Standalone Launch Product Mega Batch V1

TASK=MANASIKUNA_1448_STANDALONE_LAUNCH_PRODUCT_MEGA_BATCH_V1
BASE_SHA=a717bdbf218e3aa28132049b784313ff26ab3011
BASE_VERSION=2.9.6+38
TARGET_VERSION=2.10.0+39
TARGET_BRANCH=task/manasikuna-1448-standalone-launch-product-mega-batch-v1

## Product objective

Turn the already-integrated 1448 foundation into a visible, end-to-end standalone product path using synthetic data only.

## Included

- Pilgrim activation screen.
- Manual opaque-token activation.
- Synthetic QR preview using the same opaque token contract.
- No personal data embedded in QR/token.
- OfficialPilgrimSeed-derived local pilgrim context.
- CampaignOperationalPack-derived supervisor, accommodation, transport, Mina/Arafat camps, schedule, meeting points, and emergency contacts.
- Offline-first local snapshot using shared_preferences.
- Raw activation token is not persisted.
- Offline restore state plus stale-data indicator.
- Primary Home and bottom-navigation "رحلتي" entry points route to the new 1448 standalone product path.
- Existing legacy journey route remains present for compatibility but is no longer the primary launch entry point.
- Existing route surfaces for supervisor, accommodation/transport, schedule, emergency, and current location are reused as quick actions.
- Responsive target widths: 360, 768, 1280, 1440.
- Browser-targeted Flutter test gate on Chrome.
- Version 2.10.0+39.

## Truthful capability boundary

- DEFAULT_RUNTIME_MODE=STANDALONE.
- Synthetic campaign activation is a local product simulation, not a real campaign backend.
- NUSUK_CONNECTED is not enabled or represented as real.
- No real Nusuk API, scraping, reverse engineering, or login.
- No real lottery import.
- No real pilgrim records.
- No Supabase personal-data mutation.
- No production deployment.
- No store release.
- No baseline promotion.
- No PR or merge authorization in this task.

## Offline-first policy

The product stores the minimum operational snapshot required for local continuity:
- approved synthetic pilgrim seed;
- campaign operational pack;
- activated/saved timestamps;
- credential expiry;
- source revision.

The raw activation token itself is intentionally not persisted.

## Acceptance gates

- exact base/main reconciliation;
- target branch absent before execution;
- clean worktree;
- early git diff --check;
- exact changeset allowlist;
- focused season-1448 data/controller tests;
- focused season-1448 widget/responsive tests;
- full Flutter tests;
- Chrome browser-targeted widget UAT;
- Flutter Web release build;
- staged git diff --check;
- pubspec.lock unchanged;
- exact parent SHA and exact commit file list;
- push task branch only;
- remote task SHA readback;
- remote main unchanged;
- final worktree clean;
- PR=NOT_CREATED;
- MERGE=NOT_STARTED.


## R3 controlled resume

R2 stopped fail-closed after:
- creating the local target task branch at the exact base;
- writing the eight additive payload files;
- adding the new route constant and router wiring;
- redirecting the Home journey-card route to `/season-1448`.

R2 did not reach formatting, tests, version bump, staging, commit, push, PR, merge, baseline, or production.

Root cause:
- Windows PowerShell 5.1 parsed the BOM-less UTF-8 `.ps1` using its legacy script encoding;
- direct Arabic literals inside the script were therefore not reliable exact-match operands.

R3:
- resumes the partial worktree in place without reset/clean;
- carries Arabic replacement operands in a UTF-8 JSON sidecar loaded with .NET;
- writes the PowerShell resume script with a UTF-8 BOM;
- updates the legacy root widget test to reflect the new primary `رحلتي 1448` navigation while explicitly retaining a compatibility test for `/journey`;
- exact intended changeset is 14 repository files.


## R4 controlled resume

R3 independently reconciled the exact 11-file partial worktree, then stopped before any additional repository mutation because Windows PowerShell 5.1 treated the JSON array returned by `ConvertFrom-Json` as a single aggregate object during the replacement loop. The combined error label was:

`HOME_CARD_TITLE HOME_CARD_SUBTITLE HOME_CARD_ACTION`

R4 removes JSON-array enumeration entirely. The UTF-8 sidecar is a named object with explicit `title`, `subtitle`, and `action` properties. Each Arabic Home replacement is applied by an explicit independent call.

R3 did not reach bottom-navigation mutation, version bump, widget-test replacement, formatting, tests, staging, commit, push, PR, merge, baseline, or production.
## R6 responsive closure

R5 closed the intl/TextDirection compile conflict, then the 360px responsive test exposed a real operational-card vertical overflow of 8.9px. The single-column grid used childAspectRatio 4.2, leaving about 49px of inner vertical space after card padding while the label plus a two-line operational value required more height.

R6 replaces ratio-derived card height with explicit mainAxisExtent 104 so operational information remains visible rather than clipped or reduced. All focused, root-navigation, full, Chrome-targeted, web-build, diff, lockfile, parent and remote-readback gates are rerun before commit/push.
## R8 formatter-agnostic test closure

R7 failed before mutation because its safety pre-gate expected an exact two-line Dart block, but the prior dart format pass had wrapped 	ester.element(find.text(...)). The intended test repair was not applied.

R8 identifies the legacy compatibility test by its unique ASCII test name, scopes the edit to that test only, and structurally replaces the single 	ester.element(...) plus context.push(MunasaknaRoutes.journey) sequence regardless of Dart line wrapping. The new context is taken from رحلتي 1448 and the legacy route is opened with context.go(...). All product and execution gates are rerun before commit/push.
## R9 Home CTA responsive closure

R8 closed root navigation test isolation and all root, data, and 1448 focused responsive tests passed. The full suite then exposed a pre-existing Home-card width contract under the new copy: at 360px the journey-card CTA row overflowed horizontally by 67px. The card retained its original compact pill geometry while the action label had grown from the historical short CTA to فتح رحلتي 1448.

R9 preserves the رحلتي 1448 title, standalone/offline product description, route, layout, typography and button geometry, and shortens only the CTA to فتح الرحلة. The existing Home responsive test is run first at all target widths, then every prior product/test/build/diff/lockfile/remote gate is rerun before commit/push.
## R10 Home CTA geometry closure

R9 reduced the 360px Home journey-card overflow from 67px to 11px by shortening the CTA copy to فتح الرحلة, proving the CTA pill remained the active constraint. R10 keeps that full CTA text and changes only the CTA pill horizontal padding from 18px per side to 8px per side inside _JourneyShortcutCard. This releases 20px of horizontal budget against the observed 11px overflow without clipping, FittedBox, font-size reduction, title/description changes, or route changes.

The existing Home responsive contract runs first, followed by all root navigation, focused data, focused 1448 responsive, full Flutter, Chrome-targeted, Web build, diff hygiene, lockfile, parent, commit allowlist and remote readback gates before commit/push.
