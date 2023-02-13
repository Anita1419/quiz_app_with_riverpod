import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiz_app_with_riverpod/apiclass/question_model.dart';
import 'package:quiz_app_with_riverpod/controllers/quiz_controller.dart';
import 'package:quiz_app_with_riverpod/controllers/quiz_state.dart';
import 'package:quiz_app_with_riverpod/enums/difficulty.dart';
import 'package:quiz_app_with_riverpod/quiz_error.dart';
import 'package:quiz_app_with_riverpod/repositories/quiz/quiz_repository.dart';
import 'package:quiz_app_with_riverpod/widgets/custom_button.dart';
import 'package:quiz_app_with_riverpod/widgets/quiz_questions.dart';
import 'package:quiz_app_with_riverpod/widgets/quiz_results.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Quiz App',
        theme: ThemeData(
            primarySwatch: Colors.yellow,
            bottomSheetTheme: const BottomSheetThemeData(
                backgroundColor: Colors.transparent)),
        home: const QuizScreen(),
      ),
    );
  }
}

final quizQuestionsProvider = FutureProvider.autoDispose<List<Question>>(
  (ref) => ref.watch(quizRepositoryProvider).getQuestions(
      numQuestions: 5,
      categoryId: Random().nextInt(24) + 9,
      difficulty: Difficulty.any),
);

//1st STEP
class QuizScreen extends HookConsumerWidget {
  const QuizScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizQuestions = ref.watch(quizQuestionsProvider);
    final pageController = usePageController();
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0XFF7474BF), Color(0XFF348AC7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: quizQuestions.when(
              data: (quizQuestions) =>
                  _buildBody(context, pageController, quizQuestions, ref),
              error: (error, _) => QuizError(
                    message: error.toString(),
                  ),
              loading: () => const Center(child: CircularProgressIndicator())),
          bottomSheet: quizQuestions.maybeWhen(
            data: (questions) {
              final quizState = ref.read(QuizControllerProvider.notifier).state;
              if (!quizState.answered) return const SizedBox.shrink();
              return CustomButton(
                title: pageController.page!.toInt() + 1 < questions.length
                    ? 'Next Question'
                    : 'See Results',
                onTap: () {
                  ref.refresh(QuizControllerProvider.notifier).state;
                  ref
                      .read(QuizControllerProvider.notifier)
                      .nextQuestion(questions, pageController.page!.toInt());
                  if (pageController.page!.toInt() + 1 < questions.length) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.linear,
                    );
                  }
                },
              );
            },
            orElse: () => const SizedBox.shrink(),
          )),
    );
  }
}

Widget _buildBody(BuildContext context, PageController pageController,
    List<Question> quizQuestions, WidgetRef ref) {
  if (quizQuestions.isEmpty) {
    return const QuizError(message: "No questions found");
  }
  // ignore: invalid_use_of_protected_member
  final quizState = ref.watch(QuizControllerProvider.notifier).state;

  return quizState.status == QuizStatus.complete
      ? QuizResults(state: quizState, questions: quizQuestions)
      : QuizQuestions(
          pageController: pageController,
          state: quizState,
          questions: quizQuestions,
        );
}
