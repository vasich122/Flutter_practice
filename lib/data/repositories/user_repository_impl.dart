import '../../core/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user/user_local_data_source.dart';
import '../datasources/user/user_mapper.dart';

/// Реализация репозитория пользователя
/// Координирует работу с источниками данных
class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource _localDataSource;

  UserRepositoryImpl(this._localDataSource);

  @override
  Future<UserModel> getCurrentUser() async {
    final dto = await _localDataSource.getCurrentUser();
    return dto.toModel();
  }

  @override
  Future<void> updateUserStatus(String status) async {
    await _localDataSource.updateStatus(status);
  }

  @override
  Future<void> updateUserLogin(String login) async {
    await _localDataSource.updateLogin(login);
  }
}

