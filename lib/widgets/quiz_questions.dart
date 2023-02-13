import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html_character_entities/html_character_entities.dart';

import 'package:quiz_app_with_riverpod/apiclass/question_model.dart';
import 'package:quiz_app_with_riverpod/controllers/quiz_controller.dart';
import 'package:quiz_app_with_riverpod/controllers/quiz_state.dart';

import 'answer_card.dart';

// class QuizQuestions extends StatefulHookConsumerWidget {
//   final PageController pageController;
//   final QuizState state;
//   final List<Question> questions;

//   const QuizQuestions(
//       {super.key,
//       required this.pageController,
//       required this.state,
//       required this.questions});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return
//   }
// }

class QuizQuestions extends StatefulHookConsumerWidget {
  final PageController pageController;
  final QuizState state;
  final List<Question> questions;
  const QuizQuestions({
    super.key,
    required this.pageController,
    required this.state,
    required this.questions,
  });

  @override
  ConsumerState<QuizQuestions> createState() => _QuizQuestionsState();
}

class _QuizQuestionsState extends ConsumerState<QuizQuestions> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.questions.length,
      itemBuilder: (context, index) {
        final question = widget.questions[index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Question ${index + 1} of ${widget.questions.length}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 12.0),
              child: Text(
                HtmlCharacterEntities.decode(question.question),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Divider(
              color: Colors.grey[200],
              height: 32.0,
              thickness: 2.0,
              indent: 20.0,
              endIndent: 20.0,
            ),
            Column(
              children: question.incorrectanswers
                  .map(
                    (e) => AnswerCard(
                        answer: e,
                        isSelected: e == widget.state.selectedAnswer,
                        isCorrect: e == question.correctAnswers,
                        isDisplayingAnswer: widget.state.answered,
                        onTap: () {
                          print("on tap clicked");
                          //ref.refresh(QuizControllerProvider.notifier).state;
                          ref.refresh(QuizControllerProvider.notifier).state;
                          ref
                              .read(QuizControllerProvider.notifier)
                              .submitAnswer(question, e);
                        }),
                  )
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}
