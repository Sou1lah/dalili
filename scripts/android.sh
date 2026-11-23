#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AVD_NAME="${ANDROID_AVD:-AMANE_Pixel_6_API_36}"

for tool in adb flutter; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "Error: $tool is required. Install it and add it to PATH." >&2
    exit 1
  fi
done

if [[ "$(uname -s)" == "Linux" && -n "${WAYLAND_DISPLAY:-}" ]]; then
  export QT_QPA_PLATFORM=xcb
fi

if command -v emulator >/dev/null 2>&1; then
  EMULATOR="$(command -v emulator)"
else
  SDK_ROOT="${ANDROID_SDK_ROOT:-${ANDROID_HOME:-$HOME/Android/Sdk}}"
  EMULATOR="$SDK_ROOT/emulator/emulator"
fi

if [[ ! -x "$EMULATOR" ]]; then
  echo "Error: Android emulator executable not found at $EMULATOR." >&2
  exit 1
fi

find_emulator_device() {
  adb devices | awk '$1 ~ /^emulator-/ && $2 == "device" { print $1; exit }'
}

DEVICE="$(find_emulator_device)"
if [[ -z "$DEVICE" ]]; then
  if ! "$EMULATOR" -list-avds | grep -Fxq "$AVD_NAME"; then
    echo "Error: AVD '$AVD_NAME' is not installed. Set ANDROID_AVD to an installed AVD." >&2
    exit 1
  fi

  echo "Starting Android emulator: $AVD_NAME"
  EMULATOR_LOG="${TMPDIR:-/tmp}/dalili-emulator.log"
  "$EMULATOR" -avd "$AVD_NAME" -no-audio -no-boot-anim -no-snapshot-load >"$EMULATOR_LOG" 2>&1 &

  for _ in {1..60}; do
    DEVICE="$(find_emulator_device)"
    [[ -n "$DEVICE" ]] && break
    sleep 2
  done

  if [[ -z "$DEVICE" ]]; then
    echo "Error: Android emulator did not connect to adb. Startup log: $EMULATOR_LOG" >&2
    tail -n 40 "$EMULATOR_LOG" >&2
    exit 1
  fi
fi

if [[ -z "$DEVICE" ]]; then
  echo "Error: Android emulator did not connect to adb within 120 seconds." >&2
  exit 1
fi

adb -s "$DEVICE" wait-for-device
echo "Waiting for Android to finish booting..."
for _ in {1..90}; do
  if [[ "$(adb -s "$DEVICE" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" == "1" ]]; then
    break
  fi
  sleep 2
done

if [[ "$(adb -s "$DEVICE" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')" != "1" ]]; then
  echo "Error: Android did not finish booting within 180 seconds." >&2
  exit 1
fi

cd "$ROOT_DIR/mobile"
flutter pub get
exec flutter run -d "$DEVICE"
