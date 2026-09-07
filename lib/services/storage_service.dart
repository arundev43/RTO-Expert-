import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/exam_result_model.dart';

/// Thin wrapper around SharedPreferences. Keep ALL raw key strings here —
/// nowhere else in the app should reference a preference key directly.
/// This is what makes renaming/migrating storage safe later.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const _kStateCode = 'state_code';
  static const _kLanguageCode = 'language_code';
  static const _kThemeMode = 'theme_mode'; // 'system' | 'light' | 'dark'
  static const _kIsPremium = 'is_premium';
  static const _kUserId =
      'user_id'; // set only after login (payment or contribution)
  static const _kExamHistory = 'exam_history';
  static const _kFreeSchoolSubmissionUsed = 'free_school_submission_used';
  static const _kBookmarkedQuestionIds = 'bookmarked_question_ids';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  // --- Onboarding selection ---
  Future<void> setStateAndLanguage(
      String stateCode, String languageCode) async {
    final p = await _prefs;
    await p.setString(_kStateCode, stateCode);
    await p.setString(_kLanguageCode, languageCode);
  }

  Future<String?> getStateCode() async => (await _prefs).getString(_kStateCode);
  Future<String?> getLanguageCode() async =>
      (await _prefs).getString(_kLanguageCode);
  Future<bool> hasCompletedOnboarding() async => await getStateCode() != null;

  // --- Theme ---
  Future<void> setThemeMode(String mode) async =>
      (await _prefs).setString(_kThemeMode, mode);
  Future<String> getThemeMode() async =>
      (await _prefs).getString(_kThemeMode) ?? 'system';

  // --- Premium / login ---
  Future<void> setPremium(bool value) async =>
      (await _prefs).setBool(_kIsPremium, value);
  Future<bool> isPremium() async =>
      (await _prefs).getBool(_kIsPremium) ?? false;

  Future<void> setUserId(String userId) async =>
      (await _prefs).setString(_kUserId, userId);
  Future<String?> getUserId() async => (await _prefs).getString(_kUserId);
  Future<bool> isLoggedIn() async => await getUserId() != null;

  // --- Exam history ---
  Future<List<ExamResultModel>> getExamHistory() async {
    final raw = (await _prefs).getStringList(_kExamHistory) ?? [];
    return raw.map((e) => ExamResultModel.fromJson(jsonDecode(e))).toList();
  }

  Future<void> addExamResult(ExamResultModel result) async {
    final p = await _prefs;
    final raw = p.getStringList(_kExamHistory) ?? [];
    raw.add(jsonEncode(result.toJson()));
    await p.setStringList(_kExamHistory, raw);
  }

  // --- Driving school contribution quota ---
  Future<bool> hasUsedFreeSchoolSubmission() async =>
      (await _prefs).getBool(_kFreeSchoolSubmissionUsed) ?? false;

  Future<void> markFreeSchoolSubmissionUsed() async =>
      (await _prefs).setBool(_kFreeSchoolSubmissionUsed, true);

  // --- Bookmarks ---
  Future<Set<String>> getBookmarkedQuestionIds() async =>
      ((await _prefs).getStringList(_kBookmarkedQuestionIds) ?? []).toSet();

  Future<void> toggleBookmark(String questionId) async {
    final p = await _prefs;
    final current = (p.getStringList(_kBookmarkedQuestionIds) ?? []).toSet();
    if (!current.add(questionId)) current.remove(questionId);
    await p.setStringList(_kBookmarkedQuestionIds, current.toList());
  }
}
