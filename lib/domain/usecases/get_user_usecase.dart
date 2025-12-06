import '../../core/models/user_model.dart';
import '../repositories/user_repository.dart';

/// Use Case для получения текущего пользователя
class GetUserUseCase {
  final UserRepository _repository;

  GetUserUseCase(this._repository);

  Future<UserModel> call() => _repository.getCurrentUser();
}

