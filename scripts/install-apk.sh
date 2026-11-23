#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APK="$ROOT_DIR/dist/Dalili.apk"

if ! command -v adb >/dev/null 2>&1; then
  echo "Error: adb is required. Install Android platform-tools and add it to PATH." >&2
  exit 1
fi

if [[ ! -f "$APK" ]]; then
  echo "Error: $APK not found. Run 'npm run apk' first." >&2
  exit 1
fi

if [[ -n "${ANDROID_SERIAL:-}" ]]; then
  adb -s "$ANDROID_SERIAL" install -r "$APK"
else
  adb install -r "$APK"
fi
