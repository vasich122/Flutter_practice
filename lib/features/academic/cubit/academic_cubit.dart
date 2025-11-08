// lib/academic/cubit/academic_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class AcademicCubit extends Cubit<String> {
  AcademicCubit() : super('Участие в проекте «Умный кампус», публикация в сборнике МИРЭА');

  void updateScientificActivities(String newValue) {
    emit(newValue);
  }

  void addScientificActivity(String activity) {
    final current = state;
    final updated = current.isEmpty
        ? activity
        : '$current, $activity';
    emit(updated);
  }
}