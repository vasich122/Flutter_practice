import '../../core/models/application_model.dart';
import '../repositories/application_repository.dart';

/// Use Case для получения всех заявлений
class GetApplicationsUseCase {
  final ApplicationRepository _repository;

  GetApplicationsUseCase(this._repository);

  Future<List<ApplicationModel>> call() => _repository.getApplications();
}

