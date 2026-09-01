# MANASIKUNA v295 — Web Responsive UAT Closure

TASK=MANASIKUNA_V295_WEB_RESPONSIVE_UAT_CLOSURE
BASE_SHA=5b65c17bc13c16da183f186ae403d479af1c5dfb
TASK_BRANCH=task/manasikuna-v295-web-responsive-uat-closure
TARGET_VERSION=2.9.5+37

## Scope
- Reduce oversized Quick Services cards on wide web viewports.
- Prevent Bottom Navigation from covering body content.
- Add responsive breakpoints for 360 / 768 / 1280 / 1440 px.
- Cap the Bottom Navigation visual surface to 760 px on wide screens.
- Add responsive regression tests.
- Rebuild Flutter Web for Preview UAT.

## Breakpoints
- < 720 px: 3 quick-service columns, aspect ratio 0.92.
- 720–1099 px: 4 columns, aspect ratio 1.12.
- >= 1100 px: 6 columns, aspect ratio 1.35.
- >= 900 px: Bottom Navigation visual surface capped at 760 px.

## Safety Boundary
- NO real Nusuk API.
- NO login/auth implementation.
- NO Supabase mutation.
- NO real server write.
- NO production deployment.
- NO store release.
- NO baseline promotion.

## Required Gates
- Focused responsive widget tests: PASS.
- Full flutter test: PASS.
- flutter build web: PASS.
- Diff hygiene: PASS.
- Browser UAT at 360 / 768 / 1280 / 1440: PENDING after Preview deployment.

COMMIT=NOT_STARTED
PUSH=NOT_STARTED
PR=NOT_STARTED
MERGE=NOT_STARTED
PRODUCTION=NO
## R3 Test Discovery / R4 Closure
- R3 source apply completed and responsive tests started.
- 360px exposed a real HomeTopBar RenderFlex overflow caused by an unconstrained center label column.
- 768/1280/1440 width assertions measured a margin-owning outer Container rather than the decorated visual nav surface.
- R4 constrains the HomeTopBar center content with Expanded and bounded text.
- R4 makes the keyed Bottom Navigation surface the actual constrained visual Container.
- Resolver-only pubspec.lock drift is restored to HEAD; no dependency update is accepted.
- R4 test/build commands use --no-pub to preserve lockfile intent.
