import '../../core/models/application_model.dart';
import '../../domain/repositories/application_repository.dart';
import '../datasources/application/application_local_data_source.dart';
import '../datasources/application/application_mapper.dart';

/// Реализация репозитория заявлений
class ApplicationRepositoryImpl implements ApplicationRepository {
  final ApplicationLocalDataSource _localDataSource;

  ApplicationRepositoryImpl(this._localDataSource);

  @override
  Future<List<ApplicationModel>> getApplications() async {
    final dtos = await _localDataSource.getApplications();
    return dtos.map((dto) => dto.toModel()).toList();
  }

  @override
  Future<ApplicationModel> createApplication(String type, String description) async {
    final dto = await _localDataSource.create(type, description);
    return dto.toModel();
  }

  @override
  Future<ApplicationModel> updateApplication(
    String id,
    String type,
    String description,
  ) async {
    final dto = await _localDataSource.update(id, type, description);
    return dto.toModel();
  }

  @override
  Future<void> deleteApplication(String id) async {
    await _localDataSource.delete(id);
  }

  @override
  Future<ApplicationModel> sendApplication(String id) async {
    final dto = await _localDataSource.send(id);
    return dto.toModel();
  }
}

