# Manasakna Phase 9 — Cross-Plane Integration Gateway V1

## Scope

This batch introduces the governed source-code boundary for consuming an
authorized traveler-safe Umrah projection from MANASAKNA_BUSINESS inside
MANASAKNA_APP without merging authority or databases.

## App-side controls

- Contract version, source project, source authority, provenance and correlation
  identifiers are validated before creating JourneyContext.
- Only commercial Umrah is accepted from the commercial plane.
- Hajj responses from the commercial plane fail closed.
- Projection keys are allow-listed and forbidden commercial internals are
  rejected recursively.
- The resulting JourneyContext preserves commercialCompany authority and marks
  cross_plane_delivery explicitly.
- HTTP transport requires HTTPS except localhost and has a bounded timeout.
- The default product runtime is not rewired to a live endpoint in this batch.
- A dedicated Phase 9 preview entrypoint uses synthetic contract-exact transport.

## Current execution boundary

- No direct MANASAKNA_BUSINESS database access.
- No Supabase dependency in the gateway feature.
- No live gateway endpoint configured.
- No service secret embedded.
- No production deployment.
- No real traveler data.
- No real Nusuk or payment integration.
- No store release.
- No Phase 10 external-provider implementation.

The batch proves contract parsing, provenance, data minimization, correlation,
failure behavior and traveler-facing rendering using synthetic/non-production
evidence. Live service identity provisioning and network deployment remain
separate controlled gates.
