import '../../../core/models/math_test_model.dart';
import 'math_test_dto.dart';
extension MathTestMapper on MathTestDto {
  MathTestModel toModel() {
    return MathTestModel(
      id: id,
      title: title,
      description: description,
      topic: topic,
      questionCount: questionCount,
      difficulty: difficulty,
      category: category,
    );
  }
}

