import 'user_dto.dart';
import '../core/preferences_helper.dart';
import '../core/secure_storage_helper.dart';

class UserLocalDataSource {
  final PreferencesHelper _prefsHelper = PreferencesHelper.instance;
  final SecureStorageHelper _secureStorage = SecureStorageHelper.instance;

  static const String _defaultId = 'user_1';
  static const String _defaultFullName = 'Соваренко Василий Васильевич';
  static const String _defaultGroup = 'ИКБО-06-22';
  static const int _defaultCourse = 4;
  static const String _defaultStatus = 'онлайн';
  static const String _defaultLogin = 'student';

  Future<UserDto> getCurrentUser() async {
    final login = await _secureStorage.getLogin() ?? _defaultLogin;

    final status = await _prefsHelper.getUserStatus() ?? _defaultStatus;

    return UserDto(
      id: _defaultId,
      login: login,
      fullName: _defaultFullName,
      group: _defaultGroup,
      course: _defaultCourse,
      status: status,
    );
  }

  Future<void> updateStatus(String status) async {
    // Статус - простая настройка, используем SharedPreferences
    await _prefsHelper.saveUserStatus(status);
  }

  Future<void> updateLogin(String login) async {
    // Логин - чувствительные данные, используем только SecureStorage
    await _secureStorage.saveLogin(login);
  }
}

