import '../../core/models/user_model.dart';

/// Абстрактный интерфейс репозитория пользователя
/// Определяет контракт для работы с данными пользователя
/// на языке предметной области, без привязки к технологиям
abstract class UserRepository {
  /// Получить текущего пользователя
  Future<UserModel> getCurrentUser();

  /// Обновить статус пользователя
  Future<void> updateUserStatus(String status);

  /// Обновить логин пользователя
  Future<void> updateUserLogin(String login);
}

