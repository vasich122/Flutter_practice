import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String fullName;
  final String group;
  final int course;
  final String status;

  const ProfileState({
    required this.fullName,
    required this.group,
    required this.course,
    required this.status,
  });

  ProfileState copyWith({
    String? status,
  }) {
    return ProfileState(
      fullName: fullName,
      group: group,
      course: course,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [fullName, group, course, status];
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit()
      : super(const ProfileState(
    fullName: 'Соваренко Василий Васильевич',
    group: 'ИКБО-06-22',
    course: 4,
    status: 'онлайн',
  ));

  void updateStatus(String status) {
    emit(state.copyWith(status: status));
  }
}