#!/usr/bin/env bash
set -euo pipefail
cat <<'MSG'
manasikuna iOS release checklist:
1) Use macOS with Flutter and Xcode matching current App Store requirements.
2) Run: flutter clean && flutter pub get && cd ios && pod install && cd ..
3) Open ios/Runner.xcworkspace, set Team and Bundle ID ps.manasikuna.app.
4) Confirm PrivacyInfo.xcprivacy is included in Runner target resources.
5) Run: flutter build ipa --release
MSG
