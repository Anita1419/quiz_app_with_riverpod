//one screen contains four things
//user dosent select anything
//user select correct answer
//user select incorrect answer
//user has final score

import 'package:equatable/equatable.dart';

import 'package:quiz_app_with_riverpod/apiclass/question_model.dart';

enum QuizStatus { initial, correct, incorrect, complete }

class QuizState extends Equatable {
  final QuizStatus status;
  final String selectedAnswer;
  final List<Question> correct;
  final List<Question> incorrect;

  const QuizState(
    this.status,
    this.selectedAnswer,
    this.correct,
    this.incorrect,
  );

  bool get answered =>
      status == QuizStatus.incorrect || status == QuizStatus.correct;

  @override
  List<Object> get props => [selectedAnswer, correct, incorrect, status];

  QuizState copyWith({
    QuizStatus? status,
    String? selectedAnswer,
    List<Question>? correct,
    List<Question>? incorrect,
  }) {
    return QuizState(
      status ?? this.status,
      selectedAnswer ?? this.selectedAnswer,
      correct ?? this.correct,
      incorrect ?? this.incorrect,
    );
  }

  factory QuizState.initial() {
    return const QuizState(QuizStatus.initial, '', [], []);
  }
}
