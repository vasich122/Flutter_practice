// lib/course/cubit/course_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/course_repository.dart';
import '../../../shared/service_locator.dart';

class CourseCubit extends Cubit<Map<String, String>> {
  final CourseRepository _repository;

  CourseCubit({CourseRepository? repository})
      : _repository = repository ?? locator<CourseRepository>(),
        super({}) {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final courses = await _repository.getCourses();
      final notes = <String, String>{};
      
      for (final course in courses) {
        notes.addAll(course.notes);
      }
      emit(notes);
    } catch (e) {
      emit({});
    }
  }

  Future<void> setNote(String moduleName, String note) async {
    try {
      await _repository.saveCourseNote(moduleName, note);
      final updated = Map<String, String>.from(state);
      updated[moduleName] = note;
      emit(updated);
    } catch (e) {
      final updated = Map<String, String>.from(state);
      updated[moduleName] = note;
      emit(updated);
    }
  }

  Future<void> clearNote(String moduleName) async {
    try {
      await _repository.deleteCourseNote(moduleName);
      final updated = Map<String, String>.from(state);
      updated.remove(moduleName);
      emit(updated);
    } catch (e) {
      final updated = Map<String, String>.from(state);
      updated.remove(moduleName);
      emit(updated);
    }
  }

  String getNote(String moduleName) {
    return state[moduleName] ?? '';
  }
}