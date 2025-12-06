/// Бизнес-модель пользователя
/// Представляет пользователя в предметной области приложения
class UserModel {
  final String id;
  final String login;
  final String fullName;
  final String group;
  final int course;
  final String status;

  const UserModel({
    required this.id,
    required this.login,
    required this.fullName,
    required this.group,
    required this.course,
    required this.status,
  });

  UserModel copyWith({
    String? id,
    String? login,
    String? fullName,
    String? group,
    int? course,
    String? status,
  }) {
    return UserModel(
      id: id ?? this.id,
      login: login ?? this.login,
      fullName: fullName ?? this.fullName,
      group: group ?? this.group,
      course: course ?? this.course,
      status: status ?? this.status,
    );
  }
}

