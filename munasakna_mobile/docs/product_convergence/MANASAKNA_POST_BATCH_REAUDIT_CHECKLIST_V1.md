# MANASAKNA Post-Batch Re-Audit Checklist V1

PROGRAM_ID=MANASAKNA_1448_PRODUCT_CONVERGENCE_MEGA_BATCH_V1
POST_BATCH_REAUDIT=MANDATORY

## Product surface
- [ ] Home notification icon -> `/notifications`.
- [ ] Home notification quick service -> `/notifications`.
- [ ] Services shows pilgrim services only.
- [ ] No beta/readiness/mock/governance/integration-handoff cards in public Services.
- [ ] Services search filters locally and exposes an accessible empty state.

## Journey truthfulness
- [ ] Progress from `JourneyOverview.progress`.
- [ ] Readiness from `readinessLabelAr`.
- [ ] Current status from `currentStatusAr`.
- [ ] Next milestone from `nextMilestoneAr`.
- [ ] No fixed 65%, generic "جاهز", vaccination-only next step, or invented deadline.
- [ ] Empty steps fail safely.
- [ ] Raw provider exceptions are never shown.

## Core journeys
- [ ] Home / Journey / Rituals / Daily Companion / Phase Navigator.
- [ ] Assistant / Services / Health / Emergency / Accessibility.
- [ ] Offline / Location / Documents / Checklist / Bag.
- [ ] Group / Accommodation / Transport / Complaints / Survey / Post-Hajj.

## Browser visual UAT
- [ ] 360 / 768 / 1280 / 1440 px.
- [ ] RTL, text scaling 1.0/1.5/2.0, keyboard/focus, touch targets.
- [ ] No overflow, clipping, unreachable navigation, or misleading disabled state.

## Safety and authority
- [ ] Assistant retains no-fatwa/no-guessing boundary.
- [ ] Health remains non-diagnostic.
- [ ] No locally fabricated official requirement/status.
- [ ] Real Nusuk and real pilgrim data remain disabled.
- [ ] Official provider paths fail closed.
- [ ] Development/runtime flags remain internal; public pilgrim surfaces expose no engineering-mode banner or synthetic activation path.

## Resilience and automated gates
- [ ] Offline/reload/stale/corrupt-state/provider-failure cases.
- [ ] Focused Product Convergence tests.
- [ ] Full `flutter test`.
- [ ] Analyzer issue count <= inherited ceiling 98.
- [ ] Web release build.
- [ ] Android APK and AAB release builds.
- [ ] iOS no-codesign remains CI/macOS evidence, not guessed locally.

## Final classification
Exactly one:
`PRODUCT_CONVERGENCE_ACCEPTED_FOR_SEPARATE_BASELINE_DECISION`
`PRODUCT_CONVERGENCE_ACCEPTED_WITH_OFFICIAL_DEPENDENCIES_ONLY`
`BLOCKED_WITH_EXACT_PRODUCT_GAPS`
## Visual re-audit bounded repair closure
- [ ] Public Home exposes no development banner and routes Journey to `/journey`.
- [ ] Bottom navigation Journey routes to `/journey`, not synthetic activation.
- [ ] Shared pilgrim scaffold exposes no development banner.
- [ ] Assistant copy contains no internal FAQ/version/matrix terminology.
- [ ] Services and Journey back affordances are direction-aware under RTL.
- [ ] Journey current/next card stacks below 430 px and preserves readable two-line values.
- [ ] 360/768/1280/1440 browser screenshots re-captured after repair.
- [ ] Product Convergence focused tests, legacy widget regression, full tests, analyzer, Web/APK/AAB pass after repair.