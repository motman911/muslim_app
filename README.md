# Noor (نور) - Islamic Flutter App

Noor is an offline-first Islamic app scaffold built with Flutter and clean architecture.

## Implemented in this iteration

- Riverpod state management baseline.
- GoRouter app shell with 5 tabs: Quran, Prayer Times, Azkar, Qibla, Settings.
- Onboarding with first-run state persistence.
- Localization support for Arabic, English, and French.
- Theme mode persistence (system/light/dark).
- Quran feature using clean architecture and offline asset loading.
- Azkar feature using clean architecture, offline asset loading, and tasbeeh counter with haptic feedback.
- Prayer times feature baseline (local mocked calculation structure ready for Adhan integration).

## Project directions

- Keep feature-first clean architecture (`data`, `domain`, `presentation`).
- Add remote APIs progressively while preserving offline fallback.
- Add Hive/Drift and background jobs in next phase.

## Run

```bash
flutter pub get
flutter run
```
