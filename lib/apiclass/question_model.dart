import 'package:equatable/equatable.dart';

class Question extends Equatable {
  final String category;
  final String difficulty;
  final String question;
  final String correctAnswers;
  final List<String> incorrectanswers;
  const Question({
    required this.category,
    required this.difficulty,
    required this.question,
    required this.correctAnswers,
    required this.incorrectanswers,
  });

  @override
  List<Object?> get props =>
      [category, difficulty, question, correctAnswers, incorrectanswers];

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      category: map['category'] ?? '',
      difficulty: map['difficulty'] ?? '',
      question: map['question'] ?? '',
      correctAnswers: map['correct_answer'] ?? '',
      incorrectanswers: List<String>.from(map['incorrect_answers'] ?? [])
        ..add(map['correct_answer'] ?? '')
        ..shuffle(),
    );
  }
}
