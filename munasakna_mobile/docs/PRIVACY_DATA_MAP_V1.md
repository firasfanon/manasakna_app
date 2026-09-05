# MANASAKNA Privacy Data Map V1

Status: Wave B source-of-truth inventory for the current standalone/local synthetic build.
Production approval: **NO**
Store release approval: **NO**
Real pilgrim data: **NO**
Real Nusuk integration: **NO**

## 1. Scope and governing rule

This data map describes the current application-controlled data boundary only. It must be read with:

- `PRIVACY_POLICY_AR.md`
- `PRIVACY_POLICY_EN.md`
- `SECURITY_PRIVACY_THREAT_MODEL_V1.md`
- `REAL_DATA_SECURITY_BOUNDARY_V1.md`
- `STORE_READINESS.md`
- the exact Android/iOS/Web runtime manifests and dependency inventory of the release candidate.

Store Data Safety / App Privacy answers must be derived from the verified target-platform runtime at release time. This file does not authorize production or store submission.

## 2. Current data inventory

| Data item | Classification | Source / purpose | App storage | Retention / deletion | Sharing / transfer | Minimization / authority |
| --- | --- | --- | --- | --- | --- | --- |
| UI preferences such as language, theme and text-size settings | Local preference; generally non-sensitive | User settings for local UX | Local app preferences when the related setting is used | Persists locally until changed, platform app data is cleared, or the app is uninstalled. No account-level deletion is claimed because no account exists. | No app-operated server transfer in this build | Store only the preference value needed for UX |
| Synthetic Journey 1448 snapshot | Synthetic operational state; not real pilgrim data | Synthetic activation/campaign/group/schedule/meeting/emergency context for Offline-first restoration | `SharedPreferences` key `manasikuna_1448_launch_snapshot_v1` | Removed by the local activation-clear flow; invalid/corrupt restore cleanup also removes it; clearing app data or uninstalling removes platform-local storage | No app-operated server transfer in standalone synthetic mode | Synthetic only; restore validates schema, eligibility, context and expiry and fails closed |
| Raw activation token | Credential-like transient input | User enters a token to activate the synthetic journey | **Not persisted in the Journey 1448 snapshot** | Runtime/input lifetime only. No memory-zeroization claim is made. | No app-operated server transfer in current synthetic mode | Never persist the raw token in ordinary local snapshot storage |
| QR payload | Opaque/tokenized synthetic identifier | Local synthetic QR preview | Direct pilgrim PII is prohibited in the current QR contract | Follows the synthetic journey context; real QR retention is not authorized | No real external verification flow is enabled | QR must not directly embed pilgrim name, ID or other PII |
| Location / coordinates | Potentially sensitive precise-location data | Feature-triggered current-location assistance | No app-operated location database exists in this build; persistent location storage is not authorized by Wave B | Current-use/session handling only unless a later reviewed feature defines otherwise; OS/browser permission state is platform-controlled | Manasikuna does not send location to its own server in this build. User-initiated manual sharing is not an automatic app transfer. | Request only for the location feature; future persistence/transfer requires separate review |
| Microphone audio | Sensitive sensor input | Feature-triggered voice input | Manasikuna does not persist microphone recordings in an app-operated database | Current recognition interaction only from the app perspective | OS/browser speech-recognition service may process input under platform/provider configuration and policy | Permission only when voice input is used; no app speech-audio ingestion backend |
| Speech-recognition transcript / assistant question | User-provided text; may become sensitive depending on content | Assistant interaction | No external transcript database or account history is authorized by Wave B | Current interaction/runtime state only unless a later reviewed persistence feature is introduced | No app-operated analytics/tracking transfer; platform speech-provider boundary remains separately disclosed | Do not request unnecessary personal, health, identity, financial or credential data |
| Text-to-speech content | App/user interaction text | Spoken guidance | No app-operated TTS history database is defined in this build | Current playback/runtime handling | OS/browser TTS service may be used according to platform behavior | Process only the text necessary for requested playback |
| Application logs | Operational diagnostics | Runtime/tooling diagnostics | No PII logging store is authorized; Wave B source scan rejects ordinary `print` / `debugPrint` calls in app source | Production logging and retention policy remains a later operability gate | No analytics backend is enabled in this build | Never log pilgrim PII, raw activation secrets, speech audio, precise location, credentials or authorization tokens |
| Real pilgrim identity/eligibility data | **Prohibited in current build** | Future `OFFICIAL_PILGRIM_SEED` only | `REAL_DATA=NO`; no current storage authorized | Not applicable until separately authorized | No current transfer | Future use requires data owner, minimum-field contract, provenance, access control, retention/deletion, consent/notice where applicable, security review and production authorization |
| Real Campaign Operational Pack | **Prohibited in current build** | Future authorized campaign provider | No current real-data storage authorized | Not applicable until separately authorized | No current transfer | Minimum operational fields only; integrity, provenance, schema and expiry evidence required |
| Nusuk data | **Not connected** | Optional future officially authorized provider | `REAL_NUSUK=NO` | Not applicable | No current Nusuk transport | No scraping, reverse engineering, unofficial access or launch dependency |

## 3. Retention and deletion controls

Current deletion boundaries are local because this build has no user account and no external pilgrim database.

- Synthetic Journey 1448 state: deleted by the local activation-clear function, by fail-closed invalid/corrupt restore cleanup, or by clearing/uninstalling app data.
- Raw activation token: not persisted in the Journey 1448 snapshot.
- UI preferences: persist until changed, platform app-data clear, or uninstall. A universal in-app “delete all preferences” control is not claimed.
- Location, microphone audio, speech transcript and TTS text: no app-operated long-term database is authorized in this build. Platform providers may have their own processing/retention rules; those must be checked per target platform before store submission.
- Real pilgrim/campaign/Nusuk data: no retention rule is activated because collection/ingestion is prohibited in the current build.

## 4. Data minimization rules

1. `REAL_DATA=NO` remains the default.
2. Synthetic test data must not be silently replaced by real pilgrim data.
3. Raw activation secrets are not written to ordinary local snapshot storage.
4. QR payloads remain opaque/tokenized and contain no direct pilgrim PII.
5. Permissions are feature-triggered and limited to the capability requested.
6. No advertising, external analytics, or tracking SDK is authorized by Wave B.
7. Any future data category not listed here is fail-closed pending classification, purpose, authority, storage, retention/deletion, sharing and security review.

## 5. Store-declaration source of truth

For a future store submission, the declaration source of truth is the intersection of:

1. this data map;
2. verified target-platform runtime behavior;
3. Android/iOS/Web manifests and entitlements;
4. privacy policies;
5. `STORE_READINESS.md`;
6. dependency/SDK inventory at the exact release candidate.

If any of those disagree, the store declaration is **not ready** and must fail closed.

## 6. Explicit non-claims

`PRIVACY_DATA_MAP=COMPLETE` means complete only for the **current Wave B standalone/local synthetic data boundary**. It does not certify a future backend, real pilgrim data, Nusuk integration, payment flow, document upload, production telemetry, or store approval.