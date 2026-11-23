#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v flutter >/dev/null 2>&1; then
  echo "Error: Flutter is required. Install it and add it to PATH." >&2
  exit 1
fi

cd "$ROOT_DIR/mobile"
flutter pub get
flutter build apk --release

APK_SOURCE="$ROOT_DIR/mobile/build/app/outputs/flutter-apk/app-release.apk"
APK_DEST="$ROOT_DIR/dist/Dalili.apk"
if [[ ! -f "$APK_SOURCE" ]]; then
  echo "Error: Flutter build completed without producing $APK_SOURCE." >&2
  exit 1
fi

mkdir -p "$ROOT_DIR/dist"
cp "$APK_SOURCE" "$APK_DEST"
echo "APK created: $APK_DEST"
