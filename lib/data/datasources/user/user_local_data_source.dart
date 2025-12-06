import 'user_dto.dart';

/// Локальный источник данных для пользователя
/// Инкапсулирует работу с локальным хранилищем
class UserLocalDataSource {
  // В реальном приложении здесь будет работа с SharedPreferences, Hive, etc.
  // Для демонстрации используем in-memory хранилище
  UserDto? _cachedUser;

  UserLocalDataSource() {
    // Инициализация с дефолтными данными
    _cachedUser = UserDto(
      id: 'user_1',
      login: 'student',
      fullName: 'Соваренко Василий Васильевич',
      group: 'ИКБО-06-22',
      course: 4,
      status: 'онлайн',
    );
  }

  Future<UserDto> getCurrentUser() async {
    // Симуляция асинхронной операции
    await Future.delayed(const Duration(milliseconds: 100));
    return _cachedUser!;
  }

  Future<void> updateStatus(String status) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _cachedUser = UserDto(
      id: _cachedUser!.id,
      login: _cachedUser!.login,
      fullName: _cachedUser!.fullName,
      group: _cachedUser!.group,
      course: _cachedUser!.course,
      status: status,
    );
  }

  Future<void> updateLogin(String login) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _cachedUser = UserDto(
      id: _cachedUser!.id,
      login: login,
      fullName: _cachedUser!.fullName,
      group: _cachedUser!.group,
      course: _cachedUser!.course,
      status: _cachedUser!.status,
    );
  }
}

