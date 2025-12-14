import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  static final PreferencesHelper instance = PreferencesHelper._init();
  SharedPreferences? _prefs;

  PreferencesHelper._init();

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> saveUserStatus(String status) async {
    final p = await prefs;
    await p.setString('user_status', status);
  }

  Future<String?> getUserStatus() async {
    final p = await prefs;
    return p.getString('user_status');
  }

  Future<void> saveIsAuthorized(bool isAuthorized) async {
    final p = await prefs;
    await p.setBool('is_authorized', isAuthorized);
  }

  Future<bool> getIsAuthorized() async {
    final p = await prefs;
    return p.getBool('is_authorized') ?? false;
  }

  Future<void> saveScientificActivities(String activities) async {
    final p = await prefs;
    await p.setString('scientific_activities', activities);
  }

  Future<String?> getScientificActivities() async {
    final p = await prefs;
    return p.getString('scientific_activities');
  }

  Future<void> saveGradeNote(String gradeId, String note) async {
    final p = await prefs;
    await p.setString('grade_note_$gradeId', note);
  }

  Future<String?> getGradeNote(String gradeId) async {
    final p = await prefs;
    return p.getString('grade_note_$gradeId');
  }

  Future<void> saveClassroom(String subject, String classroom) async {
    final p = await prefs;
    await p.setString('classroom_$subject', classroom);
  }

  Future<String?> getClassroom(String subject) async {
    final p = await prefs;
    return p.getString('classroom_$subject');
  }

  // Методы для работы с заметками к модулям курсов
  Future<void> saveCourseModuleNote(String moduleName, String note) async {
    final p = await prefs;
    await p.setString('course_module_note_$moduleName', note);
  }

  Future<String?> getCourseModuleNote(String moduleName) async {
    final p = await prefs;
    return p.getString('course_module_note_$moduleName');
  }

  // Универсальный метод для сохранения строки
  Future<void> saveString(String key, String value) async {
    final p = await prefs;
    await p.setString(key, value);
  }

  // Универсальный метод для получения строки
  Future<String?> getString(String key) async {
    final p = await prefs;
    return p.getString(key);
  }

  // Настройки темы приложения
  Future<void> saveAppTheme(String theme) async {
    final p = await prefs;
    await p.setString('app_theme', theme);
  }

  Future<String> getAppTheme() async {
    final p = await prefs;
    return p.getString('app_theme') ?? 'light';
  }

  // Методы для работы с логином пользователя
  Future<void> saveUserLogin(String login) async {
    final p = await prefs;
    await p.setString('user_login', login);
  }

  Future<String?> getUserLogin() async {
    final p = await prefs;
    return p.getString('user_login');
  }

  // Очистка всех данных
  Future<void> clear() async {
    final p = await prefs;
    await p.clear();
  }
}
