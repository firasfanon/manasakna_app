# Privacy Policy - Manasikuna

## Scope of this build

This release of Manasikuna is an independent local-first companion running in development mode. It does not require account creation or login. It is not connected to Nusuk or to a real pilgrim database, and it does not use real pilgrim data.

## Local data

The app stores non-sensitive preferences locally, such as language, theme and text-size settings. It may also store a synthetic operational snapshot for the “Journey 1448” flow so local Offline-first restoration can work.

The raw activation token is not persisted in the journey snapshot, and this build does not store personal health notes.

## Real data

`REAL_DATA=NO` in this release. Any future OFFICIAL PILGRIM SEED or real Campaign Pack requires separate authorization, data minimization, documented provenance, access controls, retention rules, consent where applicable, and an independent privacy/security review before activation.

Nusuk remains an optional future provider only when an officially authorized integration exists; it is not a launch dependency for the current standalone app.

## Location

The app may request location permission when the user opens the “Current Location” feature. Coordinates are displayed locally for the user. Manasikuna does not send location to its own server in this release. The user may manually share information if they choose.

## Microphone and speech recognition

Microphone permission is requested only when voice input is used. Speech recognition can be provided by the operating system or browser and may involve processing by the platform provider according to device/browser configuration and the provider’s policies.

Manasikuna does not operate its own speech-audio ingestion server in this release and does not store microphone recordings in an app-operated database.

## Text-to-speech

Spoken guidance uses the voice service available on the operating system or browser. Manasikuna does not add advertising, external analytics, or tracking for this feature.

## Accounts

There are no user accounts in this release, so account deletion is not applicable.

## Tracking, advertising and analytics

This release does not include advertising, external tracking, or external analytics SDKs.

## Store disclosures

Privacy and Data Safety forms must be revalidated against the actual behavior of each target platform before release, especially the platform/browser speech-recognition service. This document is not by itself a store-release approval.

## Contact

Official support channels will be adopted later in the app or store listing.
