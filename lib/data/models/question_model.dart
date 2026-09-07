class QuestionModel {
  final String id;
  final String stateCode; // e.g. "TN"
  final String languageCode; // e.g. "en", "ta"
  final String topic; // Signs, Fines, Signals, Scenarios, Rules
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;
  final String? imageAsset; // for road-sign questions

  const QuestionModel({
    required this.id,
    required this.stateCode,
    required this.languageCode,
    required this.topic,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
    this.imageAsset,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) => QuestionModel(
        id: json['id'] as String,
        stateCode: json['stateCode'] as String,
        languageCode: json['languageCode'] as String,
        topic: json['topic'] as String,
        question: json['question'] as String,
        options: List<String>.from(json['options'] as List),
        correctIndex: json['correctIndex'] as int,
        explanation: json['explanation'] as String?,
        imageAsset: json['imageAsset'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'stateCode': stateCode,
        'languageCode': languageCode,
        'topic': topic,
        'question': question,
        'options': options,
        'correctIndex': correctIndex,
        'explanation': explanation,
        'imageAsset': imageAsset,
      };
}
