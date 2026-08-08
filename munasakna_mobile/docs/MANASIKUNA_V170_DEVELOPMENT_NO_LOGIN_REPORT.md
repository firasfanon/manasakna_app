# Manasikuna v1.7.0 — Development Mode Without Login

## الهدف
بدء التطوير العملي على أساس أن مشروع مناسكنا يخدم الركن الخامس: الحج، مع إبقاء التطبيق دون تسجيل دخول ودون ربط خارجي حتى تكتمل قاعدة بيانات نسك ومتطلبات السيرفر.

## التغييرات
- Added `DevelopmentModeBanner` to make the no-login development state explicit.
- Updated `MunasaknaEnvironment` with `developmentMode`, `hasLogin=false`, and `nusukBackendReady=false`.
- Updated the home hero to describe the app as the pilgrim companion for the fifth pillar.
- Added a home focus card: `محور التطوير: الحج، الركن الخامس`.
- Updated app display names on Android/iOS to `مناسكنا`.
- Updated widget test expectations for the development mode banner.

## Development Contract
- No login during this phase.
- Local/demo data only.
- No Supabase/Auth dependency yet.
- No legacy/ASP integration.
- Future backend integration must happen through Nusuk/PalWakf official APIs or repositories.

## Next Recommended Batch
Build local-first Hajj journey features:
1. Editable local pilgrim profile.
2. Hajj timeline with stage details.
3. Local checklist persistence.
4. Repository contracts ready for later Supabase implementation.
