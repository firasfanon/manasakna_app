#!/usr/bin/env bash
set -e
echo "Manasikuna Beta Smoke"
flutter clean
flutter pub get
flutter test
flutter run -d chrome
