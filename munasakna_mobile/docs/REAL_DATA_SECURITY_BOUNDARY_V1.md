# MANASAKNA Real Data Security Boundary V1

Status: design boundary only — no real-data connection is authorized by this file.

## Governing rule

```text
OFFICIAL_PILGRIM_SEED + CAMPAIGN_OPERATIONAL_PACK → MANASAKNA
```

`LOTTERY_AUTHORITY=OFFICIAL_HAJJ_SYSTEM`
`MANASAKUNA_AUTHORITY=NONE`
`MANASAKUNA_ROLE=CONSUMER_OF_APPROVED_RESULTS`

Nusuk may be one officially approved provider in the future, but it is not the only allowed provider and is not a launch dependency.

## Current state

```text
REAL_DATA=NO
REAL_NUSUK=NO
LOGIN_REQUIRED=NO
EXTERNAL_PILGRIM_DATABASE=NO
```

The current 1448 activation journey uses synthetic data only.

## Minimum future OFFICIAL PILGRIM SEED

Only fields proven necessary for the authorized purpose should be considered, for example:

- opaque pilgrim reference;
- display name only when operationally necessary;
- approved/eligible state;
- campaign/group references needed for trip context.

Passport images, financial data, broad identity documents, health records, and unrelated profile data are excluded by default and require a separate necessity/authority decision.

## Minimum future Campaign Operational Pack

Operational data may include:

- campaign/group identifiers;
- supervisor contact approved for distribution;
- accommodation and transport context;
- camps/meeting points;
- schedule;
- emergency contacts.

The pack must carry provenance, schema version, issue/expiry time and integrity/authenticity evidence appropriate to the delivery channel.

## Local storage rule

SharedPreferences is acceptable only for the current non-sensitive synthetic snapshot.

Before sensitive real data can be retained locally, Wave C/security review must decide:

- whether persistence is necessary at all;
- secure-storage/encryption mechanism;
- data-at-rest scope;
- expiry and deletion;
- device-loss/revocation behavior;
- offline access boundaries.

The raw activation credential must remain non-persistent unless a separately reviewed secure credential design explicitly supersedes this rule.

## QR rule

QR payloads must be opaque/tokenized and must not directly embed pilgrim PII. Token scope, expiry, revocation and replay protections must be specified before real use.

## Network rule

Any future provider must use authenticated TLS endpoints, least-privilege authorization, explicit schema/version contracts, bounded retries and fail-closed handling. No scraping, reverse engineering, unofficial Nusuk access, or authority expansion is permitted.

## Logging rule

No pilgrim PII, raw activation secrets, speech audio, precise location, credentials or authorization tokens may be written to ordinary application logs.

## Activation gate

Changing any of the following from `NO` to `YES` requires separate authorization and evidence:

- real pilgrim data;
- real Campaign Pack ingestion;
- backend account/login;
- Nusuk integration;
- personal-data database mutation;
- production deployment;
- store release.
