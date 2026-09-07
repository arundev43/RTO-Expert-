import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../data/models/state_model.dart';

class AppSettingsProvider extends ChangeNotifier {
  String? stateCode;
  String? languageCode;
  ThemeMode themeMode = ThemeMode.system;
  bool isPremium = false;
  bool isLoggedIn = false;
  bool _loaded = false;

  bool get isLoaded => _loaded;

  StateModel? get selectedState {
    if (stateCode == null) return null;
    try {
      return kIndianStates.firstWhere((s) => s.code == stateCode);
    } catch (_) {
      return null;
    }
  }

  Future<void> load() async {
    final storage = StorageService.instance;
    stateCode = await storage.getStateCode();
    languageCode = await storage.getLanguageCode();
    isPremium = await storage.isPremium();
    isLoggedIn = await storage.isLoggedIn();

    final mode = await storage.getThemeMode();
    themeMode = switch (mode) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    _loaded = true;
    notifyListeners();
  }

  Future<void> completeOnboarding(
      String newStateCode, String newLanguageCode) async {
    stateCode = newStateCode;
    languageCode = newLanguageCode;
    await StorageService.instance
        .setStateAndLanguage(newStateCode, newLanguageCode);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    themeMode = mode;
    final str = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await StorageService.instance.setThemeMode(str);
    notifyListeners();
  }

  /// Called after a successful payment flow (ad removal, or a paid school
  /// submission) completes login + unlocks premium in one step.
  Future<void> markLoggedInAndPremium(String userId) async {
    isLoggedIn = true;
    isPremium = true;
    await StorageService.instance.setUserId(userId);
    await StorageService.instance.setPremium(true);
    notifyListeners();
  }
}
