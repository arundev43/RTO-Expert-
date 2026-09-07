# Android SDK Version Config

Google Play requires apps to **target Android 16 (API level 36)** for all
new apps and updates as of August 31, 2026. Note: bumping this is a
one-line Gradle change, but Android 16 also enforces new adaptive-layout
rules for large screens (600dp+) — orientation/aspect-ratio locking and
edge-to-edge opt-outs are removed at this target level, so test on a
tablet-sized emulator if you plan to lock portrait-only.

## After running `flutter create --platforms=android,ios --org com.rtoexpert .`

Open `android/app/build.gradle` (or `build.gradle.kts` if Flutter
generated Kotlin DSL for your version) and set:

```groovy
android {
    compileSdk 36

    defaultConfig {
        applicationId "com.rtoexpert.rto_expert"
        minSdk 24            // Android 7.0 — safe floor for offline-first apps with wide reach
        targetSdk 36
        versionCode 1
        versionName "1.0.0"
    }
}
```

If using Kotlin DSL (`build.gradle.kts`):

```kotlin
android {
    compileSdk = 36

    defaultConfig {
        applicationId = "com.rtoexpert.rto_expert"
        minSdk = 24
        targetSdk = 36
        versionCode = 1
        versionName = "1.0.0"
    }
}
```

## Why minSdk 24

API 24 (Android 7.0, released 2016) still covers the overwhelming
majority of active Android devices in India, including budget phones
common among first-time license applicants — the core audience for this
app. Going lower (e.g. API 21) buys negligible extra reach today and
costs you newer APIs used by `geolocator`/`google_maps_flutter`. Raise
it only if a specific plugin you add later requires a higher floor.

## Checking a plugin's minimum supported SDK

If a future `flutter pub add <package>` build fails with a "requires
minSdkVersion X" Gradle error, that plugin's floor is higher than 24 —
raise `minSdk` in `build.gradle` to match, rather than pinning an old
plugin version.
