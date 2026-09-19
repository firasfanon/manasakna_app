# Manasakna Hajj Government Plane Contract V1

Baseline: ec58db5eda3f548f4971cf9aaf43a20febda50b4
Phase: 4 — Hajj Government Plane Adaptation

## Boundary
The Government Plane is the sovereign Hajj authority boundary. It owns official season state, eligibility, lottery/quota decisions and other explicitly governmental decisions. Campaign/company actors may perform only delegated operational work. A delegated actor never becomes sovereign by supplying journey data.

## Authority classes
| Domain | Required authority | Company capability |
|---|---|---|
| season / official status | GOVERNMENT | read only |
| eligibility / eligibility decision | GOVERNMENT | no sovereign mutation |
| lottery / quota / official result | GOVERNMENT | no sovereign mutation |
| campaign / group assignment | GOVERNMENT or DELEGATED_COMPANY under government context | bounded operations |
| supervisor / accommodation / room / transport / meeting point | DELEGATED_COMPANY | bounded operations |
| flight | DELEGATED_COMPANY or EXTERNAL_PROVIDER | bounded/provider data |
| guidance / support | GOVERNMENT / DELEGATED_COMPANY / COMMON_TRAVELER as labelled | scoped |
| sales / margin / commission / commercial booking | PROHIBITED_IN_HAJJ_GOVERNMENT_PLANE | none |

## Enforcement rules
1. A Hajj root JourneyContext must be government-authoritative.
2. Government-only sections must have authoritative government provenance.
3. Delegated sections may use delegated-company provenance but never imply sovereign ownership.
4. Commercial-company provenance is prohibited anywhere in Hajj.
5. External-provider provenance is permitted only when explicitly authoritative for that provider field.
6. Unknown/ambiguous authority fails closed.
7. Phase 4 introduces no production, real Nusuk, real data, cross-plane database access, or Supabase mutation.
