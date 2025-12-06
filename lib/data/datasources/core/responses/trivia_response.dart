import '../../math_test/trivia_question_dto.dart';

/// Ответ от Open Trivia Database API
class TriviaResponse {
  final int responseCode;
  final List<TriviaQuestionDto> results;

  TriviaResponse({
    required this.responseCode,
    required this.results,
  });

  factory TriviaResponse.fromJson(Map<String, dynamic> json) {
    final results = (json['results'] as List<dynamic>?)
            ?.map((item) => TriviaQuestionDto.fromJson(item as Map<String, dynamic>))
            .toList() ??
        [];

    return TriviaResponse(
      responseCode: json['response_code'] as int? ?? 0,
      results: results,
    );
  }
}

