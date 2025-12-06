import '../../../core/models/question_model.dart';
import 'trivia_question_dto.dart';
import 'dart:math';

/// Mapper для преобразования TriviaQuestionDto в QuestionModel
extension QuestionMapper on TriviaQuestionDto {
  QuestionModel toModel() {
    // Перемешиваем варианты ответов
    final allAnswers = [correctAnswer, ...incorrectAnswers];
    allAnswers.shuffle(Random());

    return QuestionModel(
      id: '${category}_${difficulty}_${question.hashCode}',
      question: _decodeHtmlEntities(question),
      answers: allAnswers.map((a) => _decodeHtmlEntities(a)).toList(),
      correctAnswer: _decodeHtmlEntities(correctAnswer),
    );
  }

  /// Декодирование HTML entities (например, &quot; -> ", &#039; -> ')
  String _decodeHtmlEntities(String text) {
    return text
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&Delta;', 'Δ')
        .replaceAll('&pi;', 'π')
        .replaceAll('&deg;', '°');
  }
}

