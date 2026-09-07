# RTO Expert — Flutter Source

A maintainable, feature-based Flutter scaffold for the RTO Expert app,
covering onboarding, Learn/Practice/Exam modes, driving-school
contributions, dark mode, and the ads/paywall rules discussed.

## Why this structure

```
lib/
  core/            # theme, colors, routing — nothing app-specific, never imports from features/
  data/
    models/        # plain Dart data classes (Question, State, DrivingSchool, ExamResult)
    repositories/  # single source of truth for reading/writing each model
  services/        # cross-cutting singletons: local storage, ads
  providers/       # ChangeNotifier state containers (Provider package)
  features/        # one folder per screen-group; each owns its screens/ only
    onboarding/
    home/          # bottom-nav shell
    learn/
    practice/
    exam/
    schools/
    more/
  widgets/         # small reusable UI pieces shared across features
```

**Rule of thumb:** a screen should only import from `providers/`,
`data/models/`, and `widgets/` — never directly from another feature's
`screens/` folder (except for simple `Navigator.push` calls). This is
what keeps the codebase from turning into spaghetti as it grows.

## What's implemented vs. stubbed

Fully wired (works offline out of the box):
- Onboarding (state → language, 2 taps)
- Learn tab (search + topic filter + explanations)
- Practice mode (untimed, instant feedback, per-topic accuracy tracking, bookmarks)
- Exam mode (10 questions / 30s each / pass at 7, countdown ring, auto-advance on timeout)
- Dark mode (Auto/Light/Dark, defaults to Auto/system)
- Driving school contribution flow + status lifecycle (pending/approved/rejected/flagged)
- Free-first-listing, paid-after rule with login-at-payment-only

Stubbed — replace with real integrations before shipping:
- `services/ads_service.dart` — swap test AdMob unit IDs for real ones
- Payment + login (`markLoggedInAndPremium` calls) — wire to your OTP/auth
  provider and a real payment SDK (Razorpay/Google Play Billing)
- `data/repositories/school_repository.dart` — replace the in-memory list
  with real API calls to your moderation backend
- `data/repositories/question_repository.dart#syncRemoteUpdates()` — pull
  incremental question-bank updates without an app store release
- Google Maps: add your API key in `android/app/src/main/AndroidManifest.xml`
  and `ios/Runner/AppDelegate.swift` per the `google_maps_flutter` docs

## Adding a new state's question bank

Drop a file at `assets/data/questions_<statecode>_<langcode>.json`
(e.g. `questions_ka_kn.json`) following the shape in
`questions_sample.json`, then register it in `pubspec.yaml` if it's
in a new folder (the whole `assets/data/` folder is already included).

## Running

```bash
flutter pub get
flutter run
```

This was written in an offline sandbox, so `flutter pub get` and a
build have not been run here — do that first thing locally to catch
any version-resolution issues before further development.
