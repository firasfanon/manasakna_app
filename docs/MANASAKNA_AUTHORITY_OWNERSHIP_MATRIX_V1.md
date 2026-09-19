# Manasakna Authority / Ownership Matrix V1

Baseline: `72dce8360b14745a5b5ef73f3c97210f37bd37a4`

| Concept | Hajj owner | Hajj company scope | Umrah owner | Traveler exposure |
|---|---|---|---|---|
| season / official status | Government | read / delegated operations only | regulatory external + company operational context | provenance required |
| eligibility / lottery / quota | Government | no sovereign mutation | N/A | official-source wording only |
| campaign / group | Government or delegated Hajj context | bounded delegated operations | Company | normalized journey context |
| supervisor | delegated operational | bounded write | Company | normalized |
| accommodation / room | delegated operational | bounded write | Company | normalized |
| transport / flight / schedule | delegated operational / external provider | bounded write | Company / provider | normalized + provenance |
| documents | authority depends on document | least privilege | Company / regulator | minimized + provenance |
| notifications / guidance | Government/common/delegated | scoped | Company/common/regulator | source-labelled |
| sales / quote / booking / margin / commission | prohibited sovereign Hajj domain | prohibited | Commercial SaaS only | never exposed as sovereign Hajj |

## Existing manasakna schema classification
- seasons, eligibility rules/checks, lottery rounds/entries/results: GOVERNMENT.
- campaigns, campaign groups/members, operational packs: DELEGATED_HAJJ unless a field is explicitly sovereign.
- activation/sessions: COMMON identity/access infrastructure, server-authorized.
- content/notifications: COMMON with per-record source authority.
- audit: COMMON control evidence; audit owner follows the action authority.
- Nusuk/other official provider preview data: EXTERNAL; preview is not official production truth.
- synthetic fixtures/tools: TEST_ONLY; never production authority.

Unknown authority remains UNKNOWN and must fail closed until explicitly classified.
