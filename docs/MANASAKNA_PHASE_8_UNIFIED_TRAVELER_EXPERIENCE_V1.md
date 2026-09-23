# Manasakna Phase 8 — Unified Traveler Experience V1

## Scope

Phase 8 makes the traveler-facing application coherent for Hajj and Umrah
without merging backend ownership or authority.

The implementation is intentionally local/synthetic for the Umrah commercial
contract. Real cross-plane exchange remains Phase 9.

## Mega Batch A — Unified Journey Experience Core

- Journey discovery and authority validation.
- Fail-closed resolver for ambiguous journey identity/authority.
- Explicit traveler journey switcher when both Hajj and Umrah are available.
- Existing Hajj journey remains government-authoritative.
- Umrah journey fixture is commercial-company authoritative for commercial
  operations only.
- Source language visibly distinguishes official government information from
  company-provided operational information.
- Journey history/count is visible without exposing office commercial data.
- Home and Journey surfaces share the same journey-selection contract.
- Existing Journey UI remains repository-driven and changes mode through the
  existing traveler preference, preserving regression behavior.

## Mega Batch B — Offline, Accessibility and UAT

- Fresh/stale/offline-snapshot labels are explicit.
- Offline Umrah fixture can be exercised without network access.
- RTL narrow viewport tests.
- 200% text-scale accessibility tests.
- Explicit semantics on journey selection.
- Hajj -> Umrah and Umrah -> Hajj integration widget tests.
- Dedicated browser UAT entrypoint: lib/phase8_preview_main.dart.
- Browser UAT may build Hajj, Umrah and offline-Umrah variants without
  adding a public engineering route to the product.

## Authority boundary

- JourneyContext remains a normalization boundary.
- Hajj root authority remains authoritative government.
- Commercial Umrah root authority is commercialCompany.
- Commercial Umrah data does not create Hajj eligibility, lottery, quota,
  or official pilgrim status.
- No direct MANASAKNA_BUSINESS database access exists in Phase 8.
- No rpc_business_*, Supabase project reference, or commercial database
  client is introduced into the unified traveler feature.
- Real cross-plane network exchange is deferred to Phase 9.

## Local contract reference

The local Umrah fixture mirrors only traveler-safe fields from the accepted
Manasakna Business commercial journey contract:

- organization,
- group,
- supervisor,
- accommodation/room,
- transport/flights,
- schedule/meeting points,
- documents,
- notifications,
- support/guidance,
- freshness/provenance.

Supplier payables, CRM internals, margins, subscriptions and other office-only
commercial fields are not exposed to the traveler.

## G8 acceptance

G8 requires:

1. Hajj single-journey scenario PASS.
2. Umrah single-journey scenario PASS.
3. Explicit multiple-journey switcher PASS.
4. Ambiguous authority fail-closed PASS.
5. Government vs company source language PASS.
6. No commercial office internals exposed PASS.
7. Existing Hajj regression PASS.
8. Offline/freshness behavior PASS.
9. Arabic RTL and 200% text-scale accessibility PASS.
10. Browser rendered UAT for Hajj and Umrah changed surfaces PASS.

## Explicit exclusions

- Production.
- Real traveler data.
- Real Nusuk.
- Real payment.
- Store release.
- MANASAKNA_BUSINESS database access.
- Phase 9 cross-plane gateway.
- Phase 10 external provider integration.
