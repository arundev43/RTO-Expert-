import 'dart:async';
import 'package:flutter/material.dart';
import '../data/models/question_model.dart';
import '../data/models/exam_result_model.dart';
import '../data/repositories/question_repository.dart';
import '../services/storage_service.dart';

enum ExamStatus { notStarted, inProgress, finished }

class ExamProvider extends ChangeNotifier {
  static const int totalQuestions = 10;
  static const int passMark = 7;
  static const int secondsPerQuestion = 30;

  List<QuestionModel> _questions = [];
  int currentIndex = 0;
  int? selectedOptionIndex;
  int correctCount = 0;
  int wrongCount = 0;
  int secondsLeft = secondsPerQuestion;
  ExamStatus status = ExamStatus.notStarted;
  Timer? _timer;
  final Stopwatch _stopwatch = Stopwatch();

  QuestionModel get currentQuestion => _questions[currentIndex];
  bool get hasNext => currentIndex < _questions.length - 1;
  int get questionNumber => currentIndex + 1;
  int get totalCount => _questions.length;

  Future<void> startExam({required String stateCode, required String languageCode}) async {
    _questions = await QuestionRepository.instance
        .generateExamSet(stateCode: stateCode, languageCode: languageCode, count: totalQuestions);
    currentIndex = 0;
    correctCount = 0;
    wrongCount = 0;
    selectedOptionIndex = null;
    status = ExamStatus.inProgress;
    _stopwatch
      ..reset()
      ..start();
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    secondsLeft = secondsPerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft <= 1) {
        _timer?.cancel();
        _autoAdvanceOnTimeout();
      } else {
        secondsLeft--;
        notifyListeners();
      }
    });
  }

  void _autoAdvanceOnTimeout() {
    // No answer selected in time counts as wrong, matching real RTO test behavior.
    if (selectedOptionIndex == null) wrongCount++;
    _goToNextOrFinish();
  }

  void selectOption(int index) {
    if (selectedOptionIndex != null) return; // lock after first tap
    selectedOptionIndex = index;
    if (index == currentQuestion.correctIndex) {
      correctCount++;
    } else {
      wrongCount++;
    }
    notifyListeners();
  }

  void nextQuestion() {
    _goToNextOrFinish();
  }

  void _goToNextOrFinish() {
    if (hasNext) {
      currentIndex++;
      selectedOptionIndex = null;
      _startTimer();
    } else {
      _finishExam();
    }
    notifyListeners();
  }

  Future<void> _finishExam() async {
    _timer?.cancel();
    _stopwatch.stop();
    status = ExamStatus.finished;
    final passed = correctCount >= passMark;
    await StorageService.instance.addExamResult(
      ExamResultModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        takenAt: DateTime.now(),
        totalQuestions: _questions.length,
        correctAnswers: correctCount,
        passed: passed,
        timeTaken: _stopwatch.elapsed,
      ),
    );
    notifyListeners();
  }

  bool get passed => correctCount >= passMark;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
