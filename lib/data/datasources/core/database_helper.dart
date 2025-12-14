import 'database.dart';
export 'database.dart';

/// Обёртка для работы с Drift базой данных
/// Используется для обратной совместимости с существующим кодом
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  final AppDatabase _database;

  DatabaseHelper._init() : _database = AppDatabase();

  AppDatabase get database => _database;

  Future<void> close() async {
    await _database.close();
  }
}

