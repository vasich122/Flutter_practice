// lib/grade/cubit/grade_note_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/grade_repository.dart';
import '../../../shared/service_locator.dart';

class GradeNoteCubit extends Cubit<Map<String, String>> {
  final GradeRepository _repository;

  GradeNoteCubit({GradeRepository? repository})
      : _repository = repository ?? locator<GradeRepository>(),
        super({}) {
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    try {
      final gradeIds = ['g1', 'g2', 'g3', 'g4', 'g5'];
      final notes = <String, String>{};
      
      for (final gradeId in gradeIds) {
        final note = await _repository.getGradeNote(gradeId);
        if (note != null && note.isNotEmpty) {
          notes[gradeId] = note;
        }
      }
      
      emit(notes);
    } catch (e) {
      emit({});
    }
  }

  Future<void> setNote(String gradeId, String note) async {
    try {
      await _repository.saveGradeNote(gradeId, note);
      final updated = Map<String, String>.from(state);
      updated[gradeId] = note;
      emit(updated);
    } catch (e) {
      final updated = Map<String, String>.from(state);
      updated[gradeId] = note;
      emit(updated);
    }
  }

  Future<void> clearNote(String gradeId) async {
    try {
      await _repository.deleteGradeNote(gradeId);
      final updated = Map<String, String>.from(state);
      updated.remove(gradeId);
      emit(updated);
    } catch (e) {
      final updated = Map<String, String>.from(state);
      updated.remove(gradeId);
      emit(updated);
    }
  }

  String getNote(String gradeId) {
    return state[gradeId] ?? '';
  }
}