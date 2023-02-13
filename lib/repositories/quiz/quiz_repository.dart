import 'dart:io';

import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiz_app_with_riverpod/apiclass/question_model.dart';
import 'package:quiz_app_with_riverpod/enums/difficulty.dart';
import '../../models/failure.dart';

final dioProvider = Provider<Dio>((ref) => Dio());
final quizRepositoryProvider =
    Provider<QuizRepository>((ref) => QuizRepository(ref));

class QuizRepository {
  final Ref _reader;

  QuizRepository(this._reader);

  Future<List<Question>> getQuestions(
      {required int numQuestions,
      required int categoryId,
      required Difficulty difficulty}) async {
    try {
      final queryParameters = {
        'type': 'multiple',
        'amount': numQuestions,
        'category': categoryId
      };
      if (difficulty != Difficulty.any) {
        queryParameters
            .addAll({'difficulty': EnumToString.convertToString(difficulty)});
      }

      final response = await _reader
          .read(dioProvider)
          .get("https://opentdb.com/api.php", queryParameters: queryParameters);

      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.data);
        final results = List<Map<String, dynamic>>.from(data['results'] ?? []);

        if (results.isNotEmpty) {
          return results.map((e) => Question.fromMap(e)).toList();
        }
      }
      return [];
    } on DioError catch (err) {
      print(err);
      throw Failure(message: err.response?.statusMessage.toString() ?? '');
    } on SocketException catch (err) {
      print(err);
      throw const Failure(message: 'Place check your connection');
    }
  }
}
