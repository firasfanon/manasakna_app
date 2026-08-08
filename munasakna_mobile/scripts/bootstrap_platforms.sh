#!/usr/bin/env bash
set -euo pipefail
flutter create --platforms=android,ios --org ps.munasakna .
echo "Re-apply store settings from docs/STORE_READINESS.md if native files are regenerated."
