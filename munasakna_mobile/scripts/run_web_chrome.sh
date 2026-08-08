#!/usr/bin/env bash
set -e
flutter clean
flutter pub get
flutter run -d chrome
