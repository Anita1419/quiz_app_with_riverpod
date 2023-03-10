import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiz_app_with_riverpod/controllers/quiz_controller.dart';
import 'package:quiz_app_with_riverpod/controllers/quiz_state.dart';
import 'package:quiz_app_with_riverpod/repositories/quiz/quiz_repository.dart';
import 'package:quiz_app_with_riverpod/widgets/custom_button.dart';

import '../apiclass/question_model.dart';

class QuizResults extends HookConsumerWidget {
  final QuizState state;
  final List<Question> questions;

  const QuizResults({super.key, required this.state, required this.questions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${state.correct.length} / ${questions.length}',
          style: const TextStyle(
              color: Colors.white, fontSize: 60.0, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const Text(
          "CORRECT",
          style: TextStyle(
              color: Colors.white, fontSize: 48.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 40.0,
        ),
        CustomButton(
            title: "New Quiz",
            onTap: () {
              ref.refresh(quizRepositoryProvider);
              ref.read(QuizControllerProvider.notifier).reset();
            })
      ],
    );
  }
}
