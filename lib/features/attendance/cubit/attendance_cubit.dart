// lib/attendance/cubit/attendance_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceCubit extends Cubit<Map<String, String>> {
  AttendanceCubit() : super({});

  void setClassroom(String subject, String room) {
    final updated = Map<String, String>.from(state);
    updated[subject] = room;
    emit(updated);
  }

  void clearClassroom(String subject) {
    final updated = Map<String, String>.from(state);
    updated.remove(subject);
    emit(updated);
  }

  String getClassroom(String subject) {
    return state[subject] ?? '';
  }
}