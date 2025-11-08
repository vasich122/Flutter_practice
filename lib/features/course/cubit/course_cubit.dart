// lib/course/cubit/course_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class CourseCubit extends Cubit<Map<String, String>> {
  CourseCubit() : super({});

  void setNote(String subject, String note) {
    final updated = Map<String, String>.from(state);
    updated[subject] = note;
    emit(updated);
  }

  void clearNote(String subject) {
    final updated = Map<String, String>.from(state);
    updated.remove(subject);
    emit(updated);
  }

  String getNote(String subject) {
    return state[subject] ?? '';
  }
}