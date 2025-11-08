// lib/main/cubit/main_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class MainState {
  final String fullName;
  final String group;
  final int course;

  const MainState({
    required this.fullName,
    required this.group,
    required this.course,
  });

  MainState copyWith({
    String? fullName,
    String? group,
    int? course,
  }) {
    return MainState(
      fullName: fullName ?? this.fullName,
      group: group ?? this.group,
      course: course ?? this.course,
    );
  }
}

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(
    const MainState(
      fullName: 'Соваренко Василий Васильевич',
      group: 'ИКБО-06-22',
      course: 4,
    ),
  );

  void updateFullName(String newFullName) {
    emit(state.copyWith(fullName: newFullName));
  }

  void updateGroup(String newGroup) {
    emit(state.copyWith(group: newGroup));
  }

  void updateCourse(int newCourse) {
    emit(state.copyWith(course: newCourse));
  }
}