# Dalili.dz

Dalili.dz is a Flutter app that helps Algerian university students find and track common university procedures. The Flutter project lives in `mobile/`.

## Requirements

- Flutter SDK and Dart
- Android SDK, `adb`, and Java 17 or newer
- Node.js and npm for the convenience commands below
- An Android Virtual Device named `AMANE_Pixel_6_API_36` (or set `ANDROID_AVD` to another AVD)

## Quick start

Install Flutter dependencies and launch the app on an Android emulator:

```sh
npm run android
```

Build a release APK:

```sh
npm run apk
```

The APK is written to `dist/Dalili.apk`. APKs are ignored by Git because they are generated build artifacts and can exceed GitHub's file size limit.

## Commands

| Command | Description |
| --- | --- |
| `npm run android` | Start the configured Android emulator if needed, wait for boot, and run Dalili. |
| `npm run apk` | Build a release APK into `dist/Dalili.apk`. |
| `npm run android:install` | Install `dist/Dalili.apk` on a connected device or emulator. |
| `npm run android:logs` | Stream Android device logs with `adb logcat`. |
| `npm run android:stop` | Shut down the connected emulator. |
| `npm test` | Run Flutter tests in `mobile/`. |
| `npm run doctor` | Show Flutter's environment diagnostics. |

Use `ANDROID_AVD=Your_AVD_Name npm run android` to choose another emulator. Set `ANDROID_SERIAL` to select a specific connected device for installation.

## Manual Flutter commands

```sh
cd mobile
flutter pub get
flutter run
flutter test
flutter build apk --release
```

The generated release APK is `mobile/build/app/outputs/flutter-apk/app-release.apk`.
