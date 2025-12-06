import '../repositories/user_repository.dart';

/// Use Case для обновления статуса пользователя
class UpdateUserStatusUseCase {
  final UserRepository _repository;

  UpdateUserStatusUseCase(this._repository);

  Future<void> call(String status) => _repository.updateUserStatus(status);
}

