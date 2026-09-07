import 'package:flutter/material.dart';
import '../data/models/question_model.dart';
import '../data/repositories/question_repository.dart';
import '../services/storage_service.dart';

class PracticeProvider extends ChangeNotifier {
  List<QuestionModel> _questions = [];
  int currentIndex = 0;
  int? selectedOptionIndex;
  String selectedTopic = 'All';
  Set<String> bookmarkedIds = {};

  // topic -> [correct, total] for the weak-areas summary
  final Map<String, List<int>> topicAccuracy = {};

  QuestionModel? get currentQuestion =>
      _questions.isEmpty ? null : _questions[currentIndex];
  int get totalCount => _questions.length;
  int get questionNumber => currentIndex + 1;
  bool get isBookmarked =>
      currentQuestion != null && bookmarkedIds.contains(currentQuestion!.id);

  Future<void> load({
    required String stateCode,
    required String languageCode,
    String topic = 'All',
  }) async {
    selectedTopic = topic;
    _questions = await QuestionRepository.instance
        .loadByTopic(stateCode: stateCode, languageCode: languageCode, topic: topic);
    bookmarkedIds = await StorageService.instance.getBookmarkedQuestionIds();
    currentIndex = 0;
    selectedOptionIndex = null;
    notifyListeners();
  }

  void selectOption(int index) {
    if (selectedOptionIndex != null || currentQuestion == null) return;
    selectedOptionIndex = index;
    final isCorrect = index == currentQuestion!.correctIndex;
    final acc = topicAccuracy.putIfAbsent(currentQuestion!.topic, () => [0, 0]);
    acc[1]++;
    if (isCorrect) acc[0]++;
    notifyListeners();
  }

  void next() {
    if (currentIndex < _questions.length - 1) {
      currentIndex++;
      selectedOptionIndex = null;
      notifyListeners();
    }
  }

  Future<void> toggleBookmark() async {
    if (currentQuestion == null) return;
    await StorageService.instance.toggleBookmark(currentQuestion!.id);
    bookmarkedIds = await StorageService.instance.getBookmarkedQuestionIds();
    notifyListeners();
  }
}
