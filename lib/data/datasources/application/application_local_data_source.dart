import 'application_dto.dart';

/// Локальный источник данных для заявлений
class ApplicationLocalDataSource {
  final List<ApplicationDto> _applications = [];
  int _nextId = 1;

  Future<List<ApplicationDto>> getApplications() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List.unmodifiable(_applications);
  }

  Future<ApplicationDto> create(String type, String description) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final application = ApplicationDto(
      id: 'app_${_nextId++}',
      type: type,
      description: description,
      status: 'черновик',
      date: DateTime.now(),
      editable: true,
    );
    _applications.add(application);
    return application;
  }

  Future<ApplicationDto> update(String id, String type, String description) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _applications.indexWhere((a) => a.id == id);
    if (index == -1) {
      throw Exception('Application not found');
    }
    final updated = ApplicationDto(
      id: id,
      type: type,
      description: description,
      status: _applications[index].status,
      date: _applications[index].date,
      editable: _applications[index].editable,
    );
    _applications[index] = updated;
    return updated;
  }

  Future<void> delete(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _applications.removeWhere((a) => a.id == id);
  }

  Future<ApplicationDto> send(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _applications.indexWhere((a) => a.id == id);
    if (index == -1) {
      throw Exception('Application not found');
    }
    final updated = ApplicationDto(
      id: id,
      type: _applications[index].type,
      description: _applications[index].description,
      status: 'отправлено',
      date: _applications[index].date,
      editable: false,
    );
    _applications[index] = updated;
    return updated;
  }
}

