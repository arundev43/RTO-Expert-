class ExamResultModel {
  final String id;
  final DateTime takenAt;
  final int totalQuestions;
  final int correctAnswers;
  final bool passed; // correctAnswers >= 7 out of 10 by default rule
  final Duration timeTaken;

  const ExamResultModel({
    required this.id,
    required this.takenAt,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.passed,
    required this.timeTaken,
  });

  factory ExamResultModel.fromJson(Map<String, dynamic> json) => ExamResultModel(
        id: json['id'] as String,
        takenAt: DateTime.parse(json['takenAt'] as String),
        totalQuestions: json['totalQuestions'] as int,
        correctAnswers: json['correctAnswers'] as int,
        passed: json['passed'] as bool,
        timeTaken: Duration(seconds: json['timeTakenSeconds'] as int),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'takenAt': takenAt.toIso8601String(),
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'passed': passed,
        'timeTakenSeconds': timeTaken.inSeconds,
      };
}
