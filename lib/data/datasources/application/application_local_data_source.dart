import 'application_dto.dart';
import '../core/database_helper.dart';
import '../core/database.dart';
import 'package:drift/drift.dart';

class ApplicationLocalDataSource {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<ApplicationDto>> getApplications() async {
    final db = _dbHelper.database;
    final query = db.select(db.applications)..orderBy([(a) => OrderingTerm(expression: a.date, mode: OrderingMode.desc)]);
    final applicationsList = await query.get();
    
    return applicationsList.map((app) => ApplicationDto(
      id: app.id,
      type: app.type,
      description: app.description,
      status: app.status,
      date: DateTime.parse(app.date),
      editable: app.editable == 1,
    )).toList();
  }

  Future<ApplicationDto> create(String type, String description) async {
    final db = _dbHelper.database;
    final id = 'app_${DateTime.now().millisecondsSinceEpoch}';
    final application = ApplicationDto(
      id: id,
      type: type,
      description: description,
      status: 'черновик',
      date: DateTime.now(),
      editable: true,
    );

    await db.into(db.applications).insert(
      ApplicationsCompanion.insert(
        id: application.id,
        type: application.type,
        description: application.description,
        status: application.status,
        date: application.date.toIso8601String(),
        editable: Value(application.editable ? 1 : 0),
      ),
    );

    return application;
  }

  Future<ApplicationDto> update(String id, String type, String description) async {
    final db = _dbHelper.database;
    final existing = await (db.select(db.applications)..where((a) => a.id.equals(id))).getSingleOrNull();

    if (existing == null) {
      throw Exception('Application not found');
    }

    final updated = ApplicationDto(
      id: id,
      type: type,
      description: description,
      status: existing.status,
      date: DateTime.parse(existing.date),
      editable: existing.editable == 1,
    );

    await (db.update(db.applications)..where((a) => a.id.equals(id))).write(
      ApplicationsCompanion(
        type: Value(updated.type),
        description: Value(updated.description),
      ),
    );

    return updated;
  }

  Future<void> delete(String id) async {
    final db = _dbHelper.database;
    await (db.delete(db.applications)..where((a) => a.id.equals(id))).go();
  }

  Future<ApplicationDto> send(String id) async {
    final db = _dbHelper.database;
    final existing = await (db.select(db.applications)..where((a) => a.id.equals(id))).getSingleOrNull();

    if (existing == null) {
      throw Exception('Application not found');
    }

    final updated = ApplicationDto(
      id: id,
      type: existing.type,
      description: existing.description,
      status: 'отправлено',
      date: DateTime.parse(existing.date),
      editable: false,
    );

    await (db.update(db.applications)..where((a) => a.id.equals(id))).write(
      ApplicationsCompanion(
        status: Value(updated.status),
        editable: const Value(0),
      ),
    );

    return updated;
  }
}

