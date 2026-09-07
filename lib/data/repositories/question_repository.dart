import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import '../models/question_model.dart';

/// Offline-first question bank. Bundled JSON ships in the app; call
/// [syncRemoteUpdates] (implement against your backend) to patch in new
/// questions without a full app store release.
class QuestionRepository {
  QuestionRepository._();
  static final QuestionRepository instance = QuestionRepository._();

  final Map<String, List<QuestionModel>> _cache = {}; // key: "TN_en"

  String _key(String stateCode, String languageCode) =>
      '${stateCode}_$languageCode';

  Future<List<QuestionModel>> loadQuestions({
    required String stateCode,
    required String languageCode,
  }) async {
    final key = _key(stateCode, languageCode);
    if (_cache.containsKey(key)) return _cache[key]!;

    try {
      final raw = await rootBundle.loadString(
          'assets/data/questions_${stateCode.toLowerCase()}_$languageCode.json');
      final list = (jsonDecode(raw) as List)
          .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _cache[key] = list;
      return list;
    } catch (_) {
      // Falls back to the generic sample bank shipped for demo/dev purposes.
      final raw =
          await rootBundle.loadString('assets/data/questions_sample.json');
      final list = (jsonDecode(raw) as List)
          .map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList();
      _cache[key] = list;
      return list;
    }
  }

  Future<List<QuestionModel>> loadByTopic({
    required String stateCode,
    required String languageCode,
    required String topic,
  }) async {
    final all =
        await loadQuestions(stateCode: stateCode, languageCode: languageCode);
    if (topic == 'All') return all;
    return all.where((q) => q.topic == topic).toList();
  }

  /// Picks 10 random questions for exam mode.
  Future<List<QuestionModel>> generateExamSet({
    required String stateCode,
    required String languageCode,
    int count = 10,
  }) async {
    final all = List<QuestionModel>.from(
      await loadQuestions(stateCode: stateCode, languageCode: languageCode),
    )..shuffle(Random());
    return all.take(count).toList();
  }

  // Stub — wire this to your backend to pull incremental question-bank
  // updates on app start/background, then write them into local storage
  // (e.g. sqflite) instead of re-bundling the app.
  Future<void> syncRemoteUpdates() async {}
}
