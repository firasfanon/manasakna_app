# MANASAKNA Pilgrim Needs Matrix V1

PROGRAM_ID=MANASAKNA_1448_PRODUCT_CONVERGENCE_MEGA_BATCH_V1
CLASSIFICATION=MANASAKNA_NATIVE | OFFICIAL_PROVIDER | HYBRID | OUT_OF_SCOPE
REAL_DATA=NO
REAL_NUSUK=NO
PRODUCTION=NO

| Pilgrim need | Responsibility | Product path | Gate |
|---|---|---|---|
| Hajj type and intention | MANASAKNA_NATIVE | Hajj type | REAUDIT_REQUIRED |
| Miqat/ihram guidance | MANASAKNA_NATIVE | Miqat | REAUDIT_REQUIRED |
| Rituals step-by-step | MANASAKNA_NATIVE | Ritual guide | REAUDIT_REQUIRED |
| Contextual Hajj questions | MANASAKNA_NATIVE | FAQ + assistant | REAUDIT_REQUIRED |
| Religious uncertainty escalation | HYBRID | Fatwa/guide boundary | REAUDIT_REQUIRED |
| Travel readiness checklist | MANASAKNA_NATIVE | Checklist | REAUDIT_REQUIRED |
| Hajj bag preparation | MANASAKNA_NATIVE | Travel bag | REAUDIT_REQUIRED |
| Local document references | MANASAKNA_NATIVE | Documents wallet | REAUDIT_REQUIRED |
| Visa/permit official status | OFFICIAL_PROVIDER | Official provider only | OFFICIAL_DEPENDENCY |
| Registration/package/payment | OFFICIAL_PROVIDER | Not owned by Manasakna | OFFICIAL_DEPENDENCY |
| Journey readiness/progress | HYBRID | Journey overview | REAUDIT_REQUIRED |
| Next journey milestone | HYBRID | Journey overview | REAUDIT_REQUIRED |
| Daily companion | HYBRID | Daily companion | REAUDIT_REQUIRED |
| Stage-aware guidance | MANASAKNA_NATIVE | Phase navigator | REAUDIT_REQUIRED |
| Official schedule changes | OFFICIAL_PROVIDER | Approved provider only | OFFICIAL_DEPENDENCY |
| Local Hajj schedule | MANASAKNA_NATIVE | Hajj schedule | REAUDIT_REQUIRED |
| Group/supervisor | HYBRID | Group supervisor | REAUDIT_REQUIRED |
| Meeting/assembly points | HYBRID | Companion/provider pack | REAUDIT_REQUIRED |
| Accommodation | HYBRID | Accommodation/transport | REAUDIT_REQUIRED |
| Transport/dispatch status | HYBRID | Accommodation/provider | REAUDIT_REQUIRED |
| Field place guidance | MANASAKNA_NATIVE | Field guide | REAUDIT_REQUIRED |
| Current device location | MANASAKNA_NATIVE | Current location | REAUDIT_REQUIRED |
| Authoritative crowd/route operations | OFFICIAL_PROVIDER | Official provider only | OFFICIAL_DEPENDENCY |
| Offline guidance | MANASAKNA_NATIVE | Offline library/snapshot | REAUDIT_REQUIRED |
| Health preparation | MANASAKNA_NATIVE | Health | REAUDIT_REQUIRED |
| Current official health rules | OFFICIAL_PROVIDER | Official source required | OFFICIAL_DEPENDENCY |
| Chronic medicine preparation | MANASAKNA_NATIVE | Health/accessibility | REAUDIT_REQUIRED |
| Heat/dehydration prevention | MANASAKNA_NATIVE | Health | REAUDIT_REQUIRED |
| Medical diagnosis | OUT_OF_SCOPE | Explicitly excluded | OUT_OF_SCOPE |
| Emergency assistance | HYBRID | Emergency/contacts/location | REAUDIT_REQUIRED |
| Elderly/ill accessibility | MANASAKNA_NATIVE | Accessibility support | REAUDIT_REQUIRED |
| Screen reader/semantics | MANASAKNA_NATIVE | App UI | REAUDIT_REQUIRED |
| Text scaling/RTL | MANASAKNA_NATIVE | App UI | REAUDIT_REQUIRED |
| Local stage reminders | MANASAKNA_NATIVE | Stage reminders | REAUDIT_REQUIRED |
| Local notifications | MANASAKNA_NATIVE | Notifications | REAUDIT_REQUIRED |
| Official urgent alerts | OFFICIAL_PROVIDER | Approved provider required | OFFICIAL_DEPENDENCY |
| Voice-assisted guidance | MANASAKNA_NATIVE | Hajj assistant/TTS | REAUDIT_REQUIRED |
| Privacy/local-data control | MANASAKNA_NATIVE | Privacy/settings | REAUDIT_REQUIRED |
| Complaints | HYBRID | Complaints | REAUDIT_REQUIRED |
| Surveys/post-Hajj feedback | HYBRID | Survey/post-Hajj | REAUDIT_REQUIRED |
| Production/store publishing | OUT_OF_SCOPE | Separate authority gate | NOT_AUTHORIZED |

`OFFICIAL_DEPENDENCY` is not a defect when Manasakna is truthful, fail-closed,
and does not impersonate official authority. Every `REAUDIT_REQUIRED` row remains
unaccepted until the mandatory post-batch product/runtime/visual re-audit.