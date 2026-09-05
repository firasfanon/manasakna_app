# MANASAKNA Wave C — Authorized Data Contract Closure V1

Status: **AUTHORIZED SINGLE DEVELOPMENT — SYNTHETIC FIXTURES ONLY**

This document records the implemented Wave C contract boundary. It does not
authorize or connect any real endpoint, real pilgrim data, Supabase personal
data mutation, Nusuk integration, production deployment, or store release.

## Governing authority

```text
LOTTERY_AUTHORITY=OFFICIAL_HAJJ_SYSTEM
MANASAKNA_AUTHORITY=NONE
MANASAKNA_ROLE=CONSUMER_OF_APPROVED_RESULTS
```

The current fixture source models the contract shape only. Its source authority
is explicitly named `official-hajj-system.synthetic-fixture`; it is not an
assertion that fixture records came from a real official system.

## Implemented contract shape

### OFFICIAL_PILGRIM_SEED

The connected runtime can require:

- contract version `official-pilgrim-seed.v1`;
- authority model;
- source authority + source revision;
- provenance reference;
- fixture/real-data classification;
- explicit approval state;
- issue/expiry timestamps;
- revocation state;
- update sequence;
- campaign/group operational context.

Wave C runtime accepts **syntheticFixture + approvedForFixtureUse only**.

### CAMPAIGN_OPERATIONAL_PACK

The connected runtime can require:

- contract version `campaign-operational-pack.v1`;
- existing pack schema version;
- campaign/group context;
- authority/provenance metadata;
- issue/expiry timestamps;
- revocation state;
- update sequence;
- integrity algorithm + digest evidence reference;
- signature evidence reference.

Wave C validates the structural/evidence contract for synthetic fixtures.
Cryptographic verification of a future real transport belongs to the separately
authorized real-endpoint adapter gate and is not claimed here.

## Opaque activation / QR rule

Activation credentials remain opaque and non-persistent. The Wave C policy
rejects a credential that directly embeds the current fixture's display name,
official reference, campaign reference, or group reference. A future real QR
transport still requires separate expiry/revocation/replay and endpoint
authorization.

## Provider failure semantics

Connected providers are bounded by a timeout. Timeout and provider exception are
classified separately. Missing, unapproved, expired, revoked, unversioned, or
context-mismatched contracts fail closed and degrade to the safer existing
fallback rather than silently activating a connected context.

## Offline snapshot compatibility

The local synthetic snapshot advances to schema version 2 and persists the
contract metadata required to validate an offline restore.

Historical schema version 1 snapshots are **not silently upgraded**. They are
rejected and cleared, after which the user can reactivate the synthetic fixture.
This is the deliberate fail-closed migration strategy for this development.

The raw activation token is still never written to the snapshot.

## Hard boundaries

```text
SYNTHETIC_FIXTURES_ONLY=YES

REAL_ENDPOINT_CONNECTION=NO
REAL_PILGRIM_DATA_INGESTION=NO
REAL_PILGRIM_DATA_MUTATION=NO
SUPABASE_PERSONAL_DATA_MUTATION=NO
REAL_NUSUK=NO

PRODUCTION=NO
STORE_RELEASE=NO

WAVE_D=NO
WAVE_E=NO
```

No code in this Wave C development may flip any of these boundaries.

## Acceptance target

```text
REAL_DATA_CONTRACTS=IMPLEMENTATION_READY_WITH_SYNTHETIC_FIXTURES
CAMPAIGN_PACK_CONTRACT=VERSIONED_FAIL_CLOSED
AUTHORITY_AND_PROVENANCE=EXPLICIT
OPAQUE_ACTIVATION_DIRECT_PII=REJECTED
PROVIDER_TIMEOUT_FAILURE_SEMANTICS=EXPLICIT
OFFLINE_SNAPSHOT_CONTRACT_METADATA=PERSISTED
LEGACY_SNAPSHOT_MIGRATION=FAIL_CLOSED_REACTIVATION
```

Passing these gates means **contract closure only**. It does not mean real-data,
Nusuk, production, or store approval.
## Toolchain compatibility normalization

The accepted baseline lockfile was last resolved under an older Flutter/Dart
solver state. The authorized execution environment is currently:

```text
FLUTTER=3.44.1
DART=3.12.1
```

An isolated reproduction from the exact baseline proved that `flutter pub get`
makes a deterministic tracked lockfile compatibility update without changing
the direct dependency declarations:

```text
meta:      1.17.0 -> 1.18.0
test_api:  0.7.10 -> 0.7.11
dart sdk:  >=3.9.0 <4.0.0 -> >=3.10.0-0 <4.0.0
```

This compatibility normalization is part of the same single integrated Wave C
development. It is not a separate patch, hotfix, dependency-upgrade batch, or
authority expansion. The execution harness accepts only the exact normalized
lockfile identity reproduced in isolation and rejects any other solver drift.

No direct dependency is added or removed by this normalization.

## Runtime timeout constructor validation

The Wave C runtime timeout remains fail-fast and bounded. The runtime constructor
is intentionally non-const because validating a `Duration` through instance
accessors is not a Dart constant expression. A non-positive timeout is rejected
with `ArgumentError` at construction time in all build modes. This is part of
the same Wave C implementation and does not expand the source scope or authority.

## Freshness versus contract-envelope validity

`CampaignOperationalPack.updatedAt` is an operational freshness timestamp.
`Manasikuna1448ContractMetadata.issuedAt` is the issuance time of the governed
contract/provenance envelope. The operational payload may legitimately predate
the envelope that attests to or transports it.

Therefore, `updatedAt < contractMetadata.issuedAt` is not by itself a contract
violation. Staleness remains a separate launch-state concern and is surfaced as
`offline_snapshot_stale` when operational data exceeds the configured freshness
window. Contract validity continues to be fail-closed for metadata version,
authority, provenance, approval, revocation, temporal validity, context, schema,
and required integrity/signature evidence.
