import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiz_app_with_riverpod/controllers/quiz_controller.dart';
import 'package:quiz_app_with_riverpod/widgets/custom_button.dart';

class QuizError extends HookConsumerWidget {
  final String message;
  const QuizError({required this.message, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          const SizedBox(
            height: 20.0,
          ),
          CustomButton(
              title: 'Retry', onTap: () => ref.refresh(QuizControllerProvider))
        ],
      ),
    );
  }
}
