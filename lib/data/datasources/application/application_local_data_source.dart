import 'application_dto.dart';
import '../core/database_helper.dart';

class ApplicationLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<ApplicationDto>> getApplications() async {
    final db = await _dbHelper.database;
    final maps = await db.query('applications', orderBy: 'date DESC');
    return maps.map((map) {
      return ApplicationDto(
        id: map['id'] as String,
        type: map['type'] as String,
        description: map['description'] as String,
        status: map['status'] as String,
        date: DateTime.parse(map['date'] as String),
        editable: (map['editable'] as int) == 1,
      );
    }).toList();
  }

  Future<ApplicationDto> create(String type, String description) async {
    final db = await _dbHelper.database;
    final id = 'app_${DateTime.now().millisecondsSinceEpoch}';
    final application = ApplicationDto(
      id: id,
      type: type,
      description: description,
      status: 'черновик',
      date: DateTime.now(),
      editable: true,
    );

    await db.insert('applications', {
      'id': application.id,
      'type': application.type,
      'description': application.description,
      'status': application.status,
      'date': application.date.toIso8601String(),
      'editable': application.editable ? 1 : 0,
    });

    return application;
  }

  Future<ApplicationDto> update(String id, String type, String description) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'applications',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      throw Exception('Application not found');
    }

    final existing = maps.first;
    final updated = ApplicationDto(
      id: id,
      type: type,
      description: description,
      status: existing['status'] as String,
      date: DateTime.parse(existing['date'] as String),
      editable: (existing['editable'] as int) == 1,
    );

    await db.update(
      'applications',
      {
        'type': updated.type,
        'description': updated.description,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    return updated;
  }

  Future<void> delete(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'applications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<ApplicationDto> send(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'applications',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      throw Exception('Application not found');
    }

    final existing = maps.first;
    final updated = ApplicationDto(
      id: id,
      type: existing['type'] as String,
      description: existing['description'] as String,
      status: 'отправлено',
      date: DateTime.parse(existing['date'] as String),
      editable: false,
    );

    await db.update(
      'applications',
      {
        'status': updated.status,
        'editable': 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    return updated;
  }
}

