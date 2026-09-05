# MANASAKNA Security & Privacy Threat Model V1

Status: Wave B implementation evidence
Applies to: standalone/local synthetic build based on `MANASAKNA_APP_BASELINE_57420DA6_20260903`
Production approval: **NO**

## 1. Current trust boundary

Current runtime facts:

- No login or user account.
- No real pilgrim database.
- `REAL_DATA=NO`.
- Nusuk is not connected.
- No app-operated analytics/tracking backend.
- Synthetic 1448 journey data may be stored locally for Offline-first restoration.
- Raw activation token is not persisted in the journey snapshot.
- Location and microphone are feature-triggered permissions.
- Speech recognition / TTS can rely on operating-system or browser services.

## 2. Protected assets

- Future pilgrim identity and eligibility data.
- Campaign/group operational data.
- Location.
- Voice input.
- Health-related information.
- Activation/authorization material.
- Local journey state.
- Integrity of official-source provenance.

## 3. Primary threat scenarios

### T1 — Authority confusion

The app could imply it is an official Nusuk/Hajj authority when it is not.

**Current control:** standalone/synthetic disclosure and independent-companion wording.

### T2 — Real data enabled without authorization

A future provider could introduce real pilgrim data before governance, consent, access control or retention design is ready.

**Current control:** `REAL_DATA=NO`; real-data integration requires a separate authorization and security/privacy review.

### T3 — Sensitive token persistence

An activation secret could be stored in ordinary local preferences.

**Current control:** raw activation token is not persisted in the journey snapshot.

### T4 — PII embedded in QR

A QR could expose pilgrim name, ID or other personal information.

**Current control:** current QR is synthetic opaque-token-only; real QR format requires separate review.

### T5 — Corrupt/stale local authorization

A stale or malformed local snapshot could reactivate an invalid journey.

**Current control:** restore revalidates schema, eligibility, campaign/group context and expiry and fails closed.

### T6 — Permission overreach

Location or microphone could be requested without a user-triggered feature.

**Current control:** permissions are limited to current-location and voice-input functions; UI disclosure is required.

### T7 — Speech-provider privacy ambiguity

Browser/OS speech recognition may involve platform-provider processing that is not an app-operated backend.

**Current control:** privacy text explicitly distinguishes app-operated data flows from platform speech services. Store disclosure must be platform-specific.

### T8 — PII or secrets in logs/source

Debug output or committed files could leak sensitive data.

**Current control:** Wave B gate rejects `print/debugPrint` in app source and scans for common private-key/API-key patterns. Future production telemetry must be privacy-safe by design.

### T9 — Cleartext transport

A future network integration could use insecure HTTP.

**Current control:** Android main manifest sets `usesCleartextTraffic=false`. Any provider integration must separately enforce TLS and authenticated endpoints.

### T10 — Dependency/supply-chain drift

Dependency/toolchain drift can change privacy or runtime behavior.

**Current control:** dependency lock and reproducibility are tracked gaps. They must be closed before production; Wave B does not silently normalize the lockfile.

## 4. Real-data prerequisites

Before `REAL_DATA=YES`, all of the following require explicit evidence:

1. Authorized data owner and purpose.
2. Minimal field contract and provenance.
3. Authentication/authorization and least privilege.
4. Secure local-storage decision for any sensitive retained data.
5. Retention/deletion rules.
6. Consent/notice where applicable.
7. Server-side audit trail and privacy-safe logging.
8. Incident/revocation path.
9. Threat-model update.
10. Store/privacy-disclosure update.
11. Runtime security UAT.
12. Separate production authorization.

## 5. Explicit non-claims

This document does not certify penetration testing, production monitoring, backend access controls, real-data security, store approval, or production readiness. Those controls require later evidence when their runtime exists.
