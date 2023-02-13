import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiz_app_with_riverpod/apiclass/question_model.dart';
import 'package:quiz_app_with_riverpod/controllers/quiz_state.dart';

final QuizControllerProvider = StateNotifierProvider.autoDispose(
  (ref) => QuizController(),
);

class QuizController extends StateNotifier<QuizState> {
  QuizController() : super(QuizState.initial());

  void submitAnswer(Question currentQuestion, String answer) {
    print(answer);
    print(currentQuestion);
    if (state.answered) return;
    if (currentQuestion.correctAnswers == answer) {
      state = state.copyWith(
        selectedAnswer: answer,
        correct: state.correct.toList()..add(currentQuestion),
        status: QuizStatus.correct,
      );
      print(" the correct answer ${state.correct}");
    } else {
      state = state.copyWith(
        selectedAnswer: answer,
        incorrect: state.incorrect.toList()..add(currentQuestion),
        status: QuizStatus.incorrect,
      );
      print(" the incorrect answer ${state.correct}");
    }
  }

  void nextQuestion(List<Question> questions, int currentIndex) {
    state = state.copyWith(
      selectedAnswer: '',
      status: currentIndex + 1 < questions.length
          ? QuizStatus.initial
          : QuizStatus.complete,
    );
  }

  void reset() {
    state = QuizState.initial();
  }
}
