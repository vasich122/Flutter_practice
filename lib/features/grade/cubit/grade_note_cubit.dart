// lib/grade/cubit/grade_note_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class GradeNoteCubit extends Cubit<Map<String, String>> {
  GradeNoteCubit() : super({});

  void setNote(String gradeId, String note) {
    final updated = Map<String, String>.from(state);
    updated[gradeId] = note;
    emit(updated);
  }

  void clearNote(String gradeId) {
    final updated = Map<String, String>.from(state);
    updated.remove(gradeId);
    emit(updated);
  }

  String getNote(String gradeId) {
    return state[gradeId] ?? '';
  }
}