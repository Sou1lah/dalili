# Dalili.dz

Android-first Flutter starter for Algerian university students. It uses sample
answers and fictional source references only; it is not connected to a backend.

## Run on an Android Studio emulator

1. Open `mobile/` in Android Studio and start an Android emulator.
2. From a terminal:

```sh
cd mobile
flutter pub get
flutter doctor
flutter run
flutter analyze
```

The emulator can reach a future local backend at `http://10.0.2.2:8000`.
Cleartext HTTP is enabled only in the Android debug manifest.

## Verification checklist

- [ ] App launches on the Android Studio emulator.
- [ ] French and Arabic text work on Home, Sources, Ask, Tracker, and Profile.
- [ ] Arabic switches the whole interface to RTL; directional send icons mirror.
- [ ] Light and dark themes work and persist after restarting the app.
- [ ] Tracker checkboxes and progress persist after restarting the app.
- [ ] `flutter analyze` completes with no errors.
- [ ] Asking about `meteo` or `weather` returns an honest not-found state.
- [ ] All displayed answers, steps, files, and page numbers are clearly samples.
