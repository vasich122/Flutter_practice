/// DTO для пользователя из локального источника данных
/// Представляет структуру данных, специфичную для локального хранилища
class UserDto {
  final String id;
  final String login;
  final String fullName;
  final String group;
  final int course;
  final String status;

  UserDto({
    required this.id,
    required this.login,
    required this.fullName,
    required this.group,
    required this.course,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'login': login,
        'fullName': fullName,
        'group': group,
        'course': course,
        'status': status,
      };

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: json['id'] as String,
        login: json['login'] as String,
        fullName: json['fullName'] as String,
        group: json['group'] as String,
        course: json['course'] as int,
        status: json['status'] as String,
      );
}

