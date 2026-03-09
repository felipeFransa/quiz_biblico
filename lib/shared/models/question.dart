class Question {
  final int id;
  final String text;
  final String correctAnswer;
  final List<String> options;
  final String category;
  final String difficulty;
  final String? reference;
  final String? explanation;

  Question({
    required this.id,
    required this.text,
    required this.correctAnswer,
    required this.options,
    required this.category,
    required this.difficulty,
    this.reference,
    this.explanation,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      text: map['text'],
      correctAnswer: map['correct_answer'] ?? map['correctAnswer'],
      options: map['options'] is String 
          ? (map['options'] as String).split('|') 
          : List<String>.from(map['options']),
      category: map['category'],
      difficulty: map['difficulty'],
      reference: map['reference'],
      explanation: map['explanation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'correct_answer': correctAnswer,
      'options': options.join('|'),
      'category': category,
      'difficulty': difficulty,
      'reference': reference,
      'explanation': explanation,
    };
  }
}
